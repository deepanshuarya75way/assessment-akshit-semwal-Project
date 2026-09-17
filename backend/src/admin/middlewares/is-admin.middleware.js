import { authenticateRequest } from "../../middlewares/auth.middleware.js";

const ADMIN_ROLES = ["admin", "superAdmin"];

export const isAdmin = async (req, res, next) => {
  try {
    const authenticatedUser = await authenticateRequest(req);
    if (!ADMIN_ROLES.includes(authenticatedUser.role)) {
      return res.status(403).json({
        message: "Admin access denied",
      });
    }

    req.user = authenticatedUser;

    return next();
  } catch (error) {
    return res.status(error.status || 401).json({
      message: error.status === 403 || error.message === "Token is required"
        ? error.message
        : "Invalid or expired token",
    });
  }
};
