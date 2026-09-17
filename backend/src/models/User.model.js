import mongoose from "mongoose";

const UserSchema = new mongoose.Schema(
  {
    email: {
      type: String,
      required: true,
      index: true,
      unique: true,
    },
    password: {
      type: String,
      required: true,
    },

    role: {
      type: String,
      enum: ["user", "admin", "superAdmin", "orderManager"],
      required: true,
      default: "user",
    },
    passwordResetTokenHash: {
      type: String,
      select: false,
      index: true,
    },
    passwordResetTokenExpiresAt: {
      type: Date,
      select: false,
    },
    refreshTokenHash: {
      type: String,
      select: false,
    },
    refreshTokenExpiresAt: {
      type: Date,
      select: false,
    },
    tokenVersion: {
      type: Number,
      default: 0,
      min: 0,
    },

    isVerified: Boolean,
    isActive: Boolean,
  },
  {
    timestamps: true,
  },
);

export default mongoose.model("UserAuthenticationModel", UserSchema);
