export const canManageOrders = async (req, res, next) => {
  const allowedRoles = ["admin", "superAdmin", "orderManager"];

  if (!allowedRoles.includes(req.user?.role)) {
    return res.status(403).json({ success: false, message: "You are not allowed to manage orders" });
  }

  return next();
};
