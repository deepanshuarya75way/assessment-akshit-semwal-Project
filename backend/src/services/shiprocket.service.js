import { shiprocketApi } from "../config/shiprocket.js";

let cachedToken = null;
let tokenCreatedAt = null;

export const getShiprocketToken = async () => {
  const tokenAge = tokenCreatedAt ? Date.now() - tokenCreatedAt : Infinity;

  const eightDays = 8 * 24 * 60 * 60 * 1000;

  if (cachedToken && tokenAge < eightDays) {
    return cachedToken;
  }

  const { data } = await shiprocketApi.post("/auth/login", {
    email: process.env.SHIPROCKET_EMAIL,
    password: process.env.SHIPROCKET_PASSWORD,
  });

  if (!data?.token) {
    throw new Error("Shiprocket token was not returned.");
  }

  cachedToken = data.token;
  tokenCreatedAt = Date.now();

  return cachedToken;
};

export const createShiprocketOrder = async (order) => {
  try {
    const token = await getShiprocketToken();

    if (!order) {
      throw new Error("Order is required.");
    }

    if (order.shiprocket?.shipmentId) {
      throw new Error("Shiprocket shipment already exists.");
    }

    const fullName = order.shippingAddress.fullName.trim();
    const nameParts = fullName.split(/\s+/);

    const firstName = nameParts[0];
    const lastName = nameParts.slice(1).join(" ");

    const payload = {
      order_id: order._id.toString(),

      order_date: new Date(order.createdAt)
        .toISOString()
        .slice(0, 19)
        .replace("T", " "),

      pickup_location: process.env.SHIPROCKET_PICKUP_LOCATION,

      billing_customer_name: firstName,
      billing_last_name: lastName || "",

      billing_address: order.shippingAddress.address,
      billing_address_2: order.shippingAddress.addressLine2 || "",

      billing_city: order.shippingAddress.city,
      billing_pincode: order.shippingAddress.pincode,
      billing_state: order.shippingAddress.state,
      billing_country: order.shippingAddress.country || "India",

      billing_email: order.shippingAddress.email,
      billing_phone: order.shippingAddress.phone,

      shipping_is_billing: true,

      order_items: order.items.map((item) => ({
        name: item.name,
        sku: item.sku,
        units: item.quantity,
        selling_price: item.price,
        discount: 0,
        tax: 0,
        hsn: "",
      })),

      payment_method: order.paymentMethod === "COD" ? "COD" : "Prepaid",

      shipping_charges: order.shippingCharge || 0,
      giftwrap_charges: 0,
      transaction_charges: 0,
      total_discount:
        (order.discount || 0) +
        (order.couponDiscount || 0) +
        (order.walletDiscount || 0),

      sub_total: order.subtotal,

      length: order.packageDetails?.length || 20,
      breadth: order.packageDetails?.breadth || 15,
      height: order.packageDetails?.height || 10,
      weight: order.packageDetails?.weight || 0.5,
    };

    const { data } = await shiprocketApi.post("/orders/create/adhoc", payload, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    return data;
  } catch (error) {
    console.error(
      "Create Shiprocket order error:",
      error.response?.data || error.message,
    );

    throw new Error(
      error.response?.data?.message ||
        error.message ||
        "Unable to create Shiprocket order.",
    );
  }
};
