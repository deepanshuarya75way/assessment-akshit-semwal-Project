import jwt from "jsonwebtoken";
import UserModel from "../models/User.model.js";

const getBearerToken = (authorization = "") => {
  const [scheme, token] = String(authorization).trim().split(/\s+/);
  return scheme?.toLowerCase() === "bearer" && token ? token : null;
};

export const authenticateRequest = async (req) => {
  const token = getBearerToken(req.headers.authorization);
  if (!token) {
    const error = new Error("Token is required");
    error.status = 401;
    throw error;
  }

  const decoded = jwt.verify(token, process.env.acess_token);
  const user = await UserModel.findById(decoded.id).select(
    "role isActive isVerified tokenVersion",
  );

  const decodedVersion = Number(decoded.tokenVersion || 0);
  if (!user || Number(user.tokenVersion || 0) !== decodedVersion) {
    const error = new Error("Invalid or expired token");
    error.status = 401;
    throw error;
  }

  if (user.isActive === false || user.isVerified === false) {
    const error = new Error("Account access denied");
    error.status = 403;
    throw error;
  }

  return {
    ...decoded,
    role: user.role,
    tokenVersion: Number(user.tokenVersion || 0),
  };
};

export const TokenVerify = async (req, res, next) => {
  try {
    req.user = await authenticateRequest(req);
    return next();
  } catch (error) {
    return res.status(error.status || 401).json({
      message: error.status === 403 || error.message === "Token is required"
        ? error.message
        : "Invalid or expired token",
    });
  }
};
