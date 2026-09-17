import OrderModel from "../models/order.model.js";
import ProductModel from "../models/product.model.js";
import mongoose from "mongoose";
import { calculateCouponDiscount } from "../utils/coupon.service.js";
import { orderError, prepareOrderData } from "./order-pricing.service.js";
import Razorpay from "razorpay";
import crypto from "crypto";

const ADMIN_PURCHASE_ROLES = ["admin", "superAdmin", "orderManager"];
const ADMIN_PURCHASE_MESSAGE =
  "Admin accounts cannot add products to cart or place orders. Please use a customer account.";

const normalizePaymentMethod = (method = "cod") => {
  const normalized = String(method).toLowerCase();
  if (normalized === "upi") return "UPI";
  if (normalized === "card") return "CARD";
  return "COD";
};

const reserveStock = async (items) => {
  const reserved = [];

  try {
    for (const item of items) {
      const result = await ProductModel.updateOne(
        { _id: item.product, stock: { $gte: item.quantity } },
        { $inc: { stock: -item.quantity } },
      );
      if (result.modifiedCount !== 1) {
        throw orderError(`${item.name} no longer has enough stock`, 409);
      }
      reserved.push(item);
    }
    return reserved;
  } catch (error) {
    await Promise.all(
      reserved.map((item) =>
        ProductModel.updateOne(
          { _id: item.product },
          { $inc: { stock: item.quantity } },
        ),
      ),
    );
    throw error;
  }
};

const restoreStock = (items) =>
  Promise.all(
    items.map((item) =>
      ProductModel.updateOne(
        { _id: item.product },
        { $inc: { stock: item.quantity } },
      ),
    ),
  );

export const PlaceOrder = async (req, res) => {
  let reservedItems = [];
  let order;
  try {
    const userId = req.user.id;
    if (ADMIN_PURCHASE_ROLES.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: ADMIN_PURCHASE_MESSAGE,
      });
    }

    const {
      items = [],
      shippingAddress,
      paymentMethod = "cod",
      coupon = null,
    } = req.body || {};
    const prepared = await prepareOrderData({
      items,
      rawShippingAddress: shippingAddress,
      coupon,
      userId,
      redeemCoupon: false,
    });
    const normalizedPaymentMethod = normalizePaymentMethod(paymentMethod);

    if (normalizedPaymentMethod === "COD") {
      reservedItems = await reserveStock(prepared.orderItems);
    }

    order = await OrderModel.create({
      user: userId,

      items: prepared.orderItems,

      shippingAddress: prepared.shippingAddress,

      paymentMethod: normalizedPaymentMethod,

      paymentStatus: "Pending",

      orderStatus: normalizedPaymentMethod === "COD" ? "Confirmed" : "Pending",

      subtotal: prepared.subtotal,

      shippingCharge: prepared.shippingCharge,

      tax: prepared.tax,

      discount: prepared.discount,

      walletDiscount: prepared.walletDiscount || 0,

      couponDiscount: prepared.couponDiscount,

      totalAmount: prepared.totalAmount,

      coupon: prepared.couponId || null,

      packageDetails: {
        length: prepared.packageDetails?.length || 20,
        breadth: prepared.packageDetails?.breadth || 15,
        height: prepared.packageDetails?.height || 10,
        weight: prepared.packageDetails?.weight || 0.5,
      },
    });

    if (coupon && normalizedPaymentMethod === "COD") {
      await calculateCouponDiscount({
        couponId: coupon,
        userId,
        items: prepared.orderItems,
        redeem: true,
      });
    }

    if (normalizedPaymentMethod !== "COD") {
      const razorpay = new Razorpay({
        key_id: process.env.RAZORPAY_KEY_ID,
        key_secret: process.env.RAZORPAY_KEY_SECRET,
      });

      const options = {
        amount: Math.round(prepared.totalAmount * 100),
        currency: "INR",
        receipt: `receipt_${order._id}`,
      };

      try {
        const razorpayOrder = await razorpay.orders.create(options);
        order.razorpayOrderId = razorpayOrder.id;
        await order.save();

        return res.status(201).json({
          success: true,
          message: "Order placed successfully, proceed to payment",
          order,
          razorpayOrderId: razorpayOrder.id,
          amount: options.amount,
          currency: options.currency,
        });
      } catch (err) {
        await OrderModel.deleteOne({
          _id: order._id,
          paymentStatus: "Pending",
        });
        return res.status(500).json({
          success: false,
          message: "Failed to create Razorpay order",
        });
      }
    }

    return res.status(201).json({
      success: true,
      message: "Order placed successfully",
      order,
    });
  } catch (error) {
    if (reservedItems.length > 0) {
      await restoreStock(reservedItems);
      reservedItems = [];
    }
    if (order?._id) await OrderModel.deleteOne({ _id: order._id });

    return res.status(error.statusCode || 500).json({
      success: false,
      message:
        error.statusCode && error.statusCode < 500
          ? error.message
          : "Unable to place order",
    });
  }
};

export const GetMyOrders = async (req, res) => {
  try {
    const userId = req.user.id;

    const orders = await OrderModel.find({ user: userId })
      .populate("items.product")
      .sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      total: orders.length,
      orders,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const GetAllOrders = async (req, res) => {
  try {
    const orders = await OrderModel.find()
      .populate("user", "email role")
      .populate("items.product")
      .sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      total: orders.length,
      orders,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const GetSingleOrder = async (req, res) => {
  try {
    const { orderId } = req.params;

    if (!mongoose.Types.ObjectId.isValid(orderId)) {
      return res.status(400).json({
        success: false,
        message: "Invalid order id",
      });
    }

    const order = await OrderModel.findById(orderId)
      .populate("user", "email role")
      .populate("items.product");

    if (!order) {
      return res.status(404).json({
        success: false,
        message: "Order not found",
      });
    }

    const isOwner = order.user._id.toString() === req.user.id;
    const isAdmin = ["admin", "superAdmin", "orderManager"].includes(
      req.user.role,
    );

    if (!isOwner && !isAdmin) {
      return res.status(403).json({
        success: false,
        message: "Unauthorized",
      });
    }

    return res.status(200).json({
      success: true,
      order,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const UpdateOrderStatus = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { orderStatus } = req.body;

    if (!mongoose.Types.ObjectId.isValid(orderId)) {
      return res
        .status(400)
        .json({ success: false, message: "Invalid order id" });
    }

    const allowedStatuses = [
      "Pending",
      "Confirmed",
      "Packed",
      "Shipped",
      "Out For Delivery",
      "Delivered",
      "Cancelled",
    ];

    if (!allowedStatuses.includes(orderStatus)) {
      return res.status(400).json({
        success: false,
        message: "Invalid order status",
      });
    }

    const order = await OrderModel.findByIdAndUpdate(
      orderId,
      { orderStatus },
      { new: true },
    );

    if (!order) {
      return res.status(404).json({
        success: false,
        message: "Order not found",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Order status updated",
      order,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const CancelOrder = async (req, res) => {
  try {
    const { orderId } = req.params;

    if (!mongoose.Types.ObjectId.isValid(orderId)) {
      return res
        .status(400)
        .json({ success: false, message: "Invalid order id" });
    }

    const existingOrder =
      await OrderModel.findById(orderId).select("user orderStatus");
    if (!existingOrder) {
      return res
        .status(404)
        .json({ success: false, message: "Order not found" });
    }
    if (String(existingOrder.user) !== req.user.id) {
      return res.status(403).json({ success: false, message: "Unauthorized" });
    }

    const order = await OrderModel.findOneAndUpdate(
      {
        _id: orderId,
        user: req.user.id,
        orderStatus: { $in: ["Pending", "Confirmed"] },
      },
      { $set: { orderStatus: "Cancelled" } },
      { returnDocument: "after" },
    );
    if (!order) {
      return res.status(400).json({
        success: false,
        message: "Order cannot be cancelled",
      });
    }

    if (order.paymentMethod === "COD" || order.paymentStatus === "Paid") {
      await restoreStock(order.items);
    }

    return res.status(200).json({
      success: true,
      message: "Order cancelled successfully",
      order,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const VerifyPayment = async (req, res) => {
  let lockedOrder;
  let reservedItems = [];
  try {
    const {
      razorpay_order_id,
      razorpay_payment_id,
      razorpay_signature,
      orderId,
    } = req.body;

    if (!mongoose.Types.ObjectId.isValid(orderId)) {
      return res
        .status(400)
        .json({ success: false, message: "Invalid order id" });
    }
    if (!razorpay_order_id || !razorpay_payment_id || !razorpay_signature) {
      return res.status(400).json({
        success: false,
        message: "Payment verification fields are required",
      });
    }

    const order = await OrderModel.findOne({ _id: orderId, user: req.user.id });
    if (!order) {
      return res
        .status(404)
        .json({ success: false, message: "Order not found" });
    }

    if (order.paymentStatus === "Paid") {
      return res.status(200).json({
        success: true,
        message: "Payment already verified",
        order,
      });
    }
    if (!order.razorpayOrderId || order.razorpayOrderId !== razorpay_order_id) {
      return res.status(400).json({
        success: false,
        message: "Payment does not belong to this order",
      });
    }
    if (!process.env.RAZORPAY_KEY_SECRET) {
      return res.status(503).json({
        success: false,
        message: "Payment verification is unavailable",
      });
    }

    const body = `${order.razorpayOrderId}|${razorpay_payment_id}`;

    const expectedSignature = crypto
      .createHmac("sha256", process.env.RAZORPAY_KEY_SECRET)
      .update(body.toString())
      .digest("hex");

    const expectedBuffer = Buffer.from(expectedSignature, "utf8");
    const receivedBuffer = Buffer.from(String(razorpay_signature), "utf8");
    const isAuthentic =
      expectedBuffer.length === receivedBuffer.length &&
      crypto.timingSafeEqual(expectedBuffer, receivedBuffer);

    if (!isAuthentic) {
      return res.status(400).json({
        success: false,
        message: "Invalid signature",
      });
    }

    lockedOrder = await OrderModel.findOneAndUpdate(
      {
        _id: order._id,
        user: req.user.id,
        paymentStatus: "Pending",
        paymentVerifiedAt: null,
      },
      { $set: { paymentVerifiedAt: new Date() } },
      { returnDocument: "after" },
    );
    if (!lockedOrder) {
      return res.status(409).json({
        success: false,
        message: "Payment verification is already in progress",
      });
    }

    reservedItems = await reserveStock(lockedOrder.items);
    lockedOrder.razorpayPaymentId = razorpay_payment_id;
    lockedOrder.razorpaySignature = razorpay_signature;
    lockedOrder.paymentStatus = "Paid";
    lockedOrder.orderStatus = "Confirmed";
    await lockedOrder.save();

    if (lockedOrder.coupon) {
      try {
        await calculateCouponDiscount({
          couponId: lockedOrder.coupon,
          userId: lockedOrder.user,
          items: lockedOrder.items,
          redeem: true,
        });
      } catch (error) {
        console.error("Coupon redemption recording failed:", error.message);
      }
    }

    return res.status(200).json({
      success: true,
      message: "Payment verified successfully",
      order: lockedOrder,
    });
  } catch (error) {
    if (reservedItems.length > 0) await restoreStock(reservedItems);
    if (lockedOrder?._id) {
      await OrderModel.updateOne(
        { _id: lockedOrder._id, paymentStatus: "Pending" },
        { $set: { paymentVerifiedAt: null } },
      );
    }
    return res.status(error.statusCode || 500).json({
      success: false,
      message:
        error.statusCode && error.statusCode < 500
          ? error.message
          : "Payment verification failed",
    });
  }
};
