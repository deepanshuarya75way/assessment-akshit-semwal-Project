import express from "express";
import {
  addToCart,
  singleProduct,
  updateQuantity,
  incrementQuantity,
  decrementQuantity,
  getCart,
  deleteCartProduct,
  clearCart,
} from "../controllers/cart.controller.js";
import { TokenVerify } from "../../middlewares/auth.middleware.js";

const router = express.Router();

/**
 * Test route
 */
router.get("/", (req, res) => {
  return res.status(200).json({
    success: true,
    message: "Cart API is working",
  });
});

/**
 * Add multiple products
 *
 * POST /cart/bulk
 */
router.post("/bulk", TokenVerify, addToCart);

/**
 * Add one product
 *
 * POST /cart/add
 */
router.post("/add", TokenVerify, singleProduct);

/**
 * Set exact quantity
 *
 * PATCH /cart/quantity
 */
router.patch("/quantity", TokenVerify, updateQuantity);

/**
 * Increase quantity by one
 *
 * PATCH /cart/increment-quantity
 */
router.patch("/increment-quantity", TokenVerify, incrementQuantity);

/**
 * Decrease quantity by one
 *
 * PATCH /cart/decrement-quantity
 */
router.patch("/decrement-quantity", TokenVerify, decrementQuantity);

/**
 * Get logged-in user's cart
 *
 * GET /cart/me
 */
router.get("/me", TokenVerify, getCart);

/**
 * Delete one cart item
 *
 * DELETE /cart/delete
 */
router.delete("/delete", TokenVerify, deleteCartProduct);

/**
 * Remove all cart items
 *
 * DELETE /cart/clear
 */
router.delete("/clear", TokenVerify, clearCart);

export default router;
