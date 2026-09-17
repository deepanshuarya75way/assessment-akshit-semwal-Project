import mongoose from "mongoose";

const OrderItemSchema = new mongoose.Schema(
  {
    product: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "ProductModel",
      required: true,
    },

    name: {
      type: String,
      required: true,
      trim: true,
    },

    sku: {
      type: String,
      required: true,
      trim: true,
      uppercase: true,
    },

    image: {
      type: String,
      default: "",
    },

    price: {
      type: Number,
      required: true,
      min: 0,
    },

    quantity: {
      type: Number,
      required: true,
      min: 1,
    },
  },
  {
    _id: false,
  },
);

const OrderSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "UserAuthenticationModel",
      required: true,
      index: true,
    },

    items: {
      type: [OrderItemSchema],
      required: true,
      validate: {
        validator: (value) =>
          Array.isArray(value) && value.length > 0,
        message: "Order must contain at least one product.",
      },
    },

    shippingAddress: {
      fullName: {
        type: String,
        required: true,
        trim: true,
      },

      email: {
        type: String,
        required: true,
        trim: true,
        lowercase: true,
      },

      phone: {
        type: String,
        required: true,
        trim: true,
      },

      address: {
        type: String,
        required: true,
        trim: true,
      },

      addressLine2: {
        type: String,
        default: "",
        trim: true,
      },

      city: {
        type: String,
        required: true,
        trim: true,
      },

      state: {
        type: String,
        required: true,
        trim: true,
      },

      pincode: {
        type: String,
        required: true,
        trim: true,
      },

      country: {
        type: String,
        default: "India",
        trim: true,
      },
    },

    paymentMethod: {
      type: String,
      enum: ["COD", "RAZORPAY"],
      default: "COD",
    },

    paymentStatus: {
      type: String,
      enum: ["Pending", "Paid", "Failed", "Refunded"],
      default: "Pending",
      index: true,
    },

    orderStatus: {
      type: String,
      enum: [
        "Pending",
        "Confirmed",
        "Packed",
        "Shipped",
        "In Transit",
        "Out For Delivery",
        "Delivered",
        "Cancelled",
        "RTO",
      ],
      default: "Pending",
      index: true,
    },

    subtotal: {
      type: Number,
      required: true,
      min: 0,
    },

    shippingCharge: {
      type: Number,
      default: 0,
      min: 0,
    },

    tax: {
      type: Number,
      default: 0,
      min: 0,
    },

    discount: {
      type: Number,
      default: 0,
      min: 0,
    },

    walletDiscount: {
      type: Number,
      default: 0,
      min: 0,
    },

    couponDiscount: {
      type: Number,
      default: 0,
      min: 0,
    },

    coupon: {
      type: String,
      default: null,
      trim: true,
    },

    totalAmount: {
      type: Number,
      required: true,
      min: 0,
    },

    razorpayOrderId: {
      type: String,
      default: null,
      index: true,
    },

    razorpayPaymentId: {
      type: String,
      default: null,
      index: true,
    },

    razorpaySignature: {
      type: String,
      default: null,
    },

    paymentVerifiedAt: {
      type: Date,
      default: null,
    },

    shiprocket: {
      orderId: {
        type: String,
        default: null,
      },

      shipmentId: {
        type: String,
        default: null,
        index: true,
      },

      awbCode: {
        type: String,
        default: null,
        index: true,
      },

      courierId: {
        type: String,
        default: null,
      },

      courierName: {
        type: String,
        default: null,
      },

      trackingUrl: {
        type: String,
        default: null,
      },

      shipmentStatus: {
        type: String,
        default: null,
      },

      pickupScheduled: {
        type: Boolean,
        default: false,
      },

      pickupScheduledAt: {
        type: Date,
        default: null,
      },

      labelUrl: {
        type: String,
        default: null,
      },

      manifestUrl: {
        type: String,
        default: null,
      },

      shipmentCreatedAt: {
        type: Date,
        default: null,
      },
    },

    packageDetails: {
      length: {
        type: Number,
        default: 20,
        min: 0.1,
      },

      breadth: {
        type: Number,
        default: 15,
        min: 0.1,
      },

      height: {
        type: Number,
        default: 10,
        min: 0.1,
      },

      weight: {
        type: Number,
        default: 0.5,
        min: 0.01,
      },
    },

    cancellationReason: {
      type: String,
      default: null,
      trim: true,
    },

    cancelledAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
  },
);

OrderSchema.index({
  user: 1,
  createdAt: -1,
});

export default mongoose.model("Order", OrderSchema);