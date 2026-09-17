import mongoose from "mongoose";
import cartModel from "../../models/cart.model.js";
import ProductModel from "../../models/product.model.js";

const ADMIN_PURCHASE_ROLES = ["admin", "superadmin", "ordermanager"];

const ADMIN_PURCHASE_MESSAGE =
  "Admin accounts cannot add products to cart or place orders. Please use a customer account.";

/* -------------------------------------------------------------------------- */
/*                              Error Utilities                               */
/* -------------------------------------------------------------------------- */

const createError = (message, status = 500) => {
  const error = new Error(message);
  error.status = status;
  return error;
};

const sendErrorResponse = (res, error) => {
  const status = error.status || 500;

  if (status === 500) {
    console.error("Cart controller error:", error);
  }

  return res.status(status).json({
    success: false,
    message:
      status === 500
        ? "Something went wrong while processing the cart"
        : error.message,
  });
};

/* -------------------------------------------------------------------------- */
/*                              Role Validation                               */
/* -------------------------------------------------------------------------- */

const assertCustomerCanPurchase = (user = {}) => {
  const role = String(user.role || "")
    .trim()
    .toLowerCase();

  if (ADMIN_PURCHASE_ROLES.includes(role)) {
    throw createError(ADMIN_PURCHASE_MESSAGE, 403);
  }
};

/* -------------------------------------------------------------------------- */
/*                              ID Validation                                 */
/* -------------------------------------------------------------------------- */

const validateObjectId = (value, fieldName = "id") => {
  if (!value || !mongoose.Types.ObjectId.isValid(value)) {
    throw createError(`Invalid ${fieldName}`, 400);
  }

  return String(value);
};

/* -------------------------------------------------------------------------- */
/*                            Quantity Validation                             */
/* -------------------------------------------------------------------------- */

const normalizeQuantity = (value, defaultValue = 1) => {
  const rawValue =
    value === undefined || value === null || value === ""
      ? defaultValue
      : value;

  const quantity = Number(rawValue);

  if (!Number.isInteger(quantity) || quantity < 1) {
    throw createError("Quantity must be a positive whole number", 400);
  }

  return quantity;
};

/* -------------------------------------------------------------------------- */
/*                              Variant Helpers                               */
/* -------------------------------------------------------------------------- */

const normalizeSelectedVariants = (selectedVariants = {}) => {
  if (
    !selectedVariants ||
    typeof selectedVariants !== "object" ||
    Array.isArray(selectedVariants)
  ) {
    return {};
  }

  return Object.entries(selectedVariants).reduce(
    (normalizedVariants, [key, value]) => {
      const normalizedKey = String(key).trim().toLowerCase();

      const normalizedValue = String(value ?? "")
        .trim()
        .toLowerCase();

      if (normalizedKey && normalizedValue) {
        normalizedVariants[normalizedKey] = normalizedValue;
      }

      return normalizedVariants;
    },
    {},
  );
};

const buildVariantKey = (selectedVariants = {}) => {
  return Object.keys(selectedVariants)
    .sort()
    .map((key) => `${key}:${selectedVariants[key]}`)
    .join("|");
};

/* -------------------------------------------------------------------------- */
/*                               Cart Helpers                                 */
/* -------------------------------------------------------------------------- */

const getProductId = (item = {}) => {
  return item.productId || item.product || item.id || item._id;
};

const getOrCreateCart = async (userId) => {
  try {
    return await cartModel.findOneAndUpdate(
      { user: userId },
      {
        $setOnInsert: {
          user: userId,
          items: [],
        },
      },
      {
        returnDocument: "after",
        upsert: true,
        runValidators: true,
        setDefaultsOnInsert: true,
      },
    );
  } catch (error) {
    if (error.code === 11000) {
      return cartModel.findOne({ user: userId });
    }
    throw error;
  }
};

const populateCart = async (cart) => {
  if (!cart) {
    return null;
  }

  await cart.populate({
    path: "items.product",
    populate: {
      path: "category_id",
      select: "name",
    },
  });

  return cart;
};

const findCartItem = (cart, { cartItemId, productId, variantKey = "" }) => {
  if (!cart) {
    return null;
  }

  if (cartItemId) {
    return cart.items.find((item) => String(item._id) === String(cartItemId));
  }

  if (!productId) {
    return null;
  }

  return cart.items.find(
    (item) =>
      String(item.product) === String(productId) &&
      String(item.variantKey || "") === String(variantKey || ""),
  );
};

const findCartItemFromRequest = (cart, body = {}) => {
  const cartItemId = body.cartItemId;

  if (cartItemId) {
    validateObjectId(cartItemId, "cart item id");

    return findCartItem(cart, {
      cartItemId,
    });
  }

  const productId = body.productId || body.product;

  validateObjectId(productId, "product id");

  const selectedVariants = normalizeSelectedVariants(body.selectedVariants);

  const variantKey = buildVariantKey(selectedVariants);

  return findCartItem(cart, {
    productId,
    variantKey,
  });
};

/* -------------------------------------------------------------------------- */
/*                         Request Item Normalization                         */
/* -------------------------------------------------------------------------- */

const prepareCartItems = (items = []) => {
  if (!Array.isArray(items) || items.length === 0) {
    throw createError("Items are required", 400);
  }

  const itemMap = new Map();

  for (const item of items) {
    const productId = validateObjectId(getProductId(item), "product id");

    const quantity = normalizeQuantity(item.quantity ?? item.qty);

    const selectedVariants = normalizeSelectedVariants(item.selectedVariants);

    const variantKey = buildVariantKey(selectedVariants);

    const uniqueKey = `${productId}:${variantKey}`;

    const existingItem = itemMap.get(uniqueKey);

    if (existingItem) {
      existingItem.quantity += quantity;
    } else {
      itemMap.set(uniqueKey, {
        productId,
        quantity,
        selectedVariants,
        variantKey,
      });
    }
  }

  return Array.from(itemMap.values());
};

/* -------------------------------------------------------------------------- */
/*                            Add Items Service                               */
/* -------------------------------------------------------------------------- */

const addItemsToCart = async (userId, requestItems) => {
  const items = prepareCartItems(requestItems);

  const productIds = [...new Set(items.map((item) => item.productId))];

  /*
   * One database query for all products instead of
   * one query for every cart item.
   */
  const products = await ProductModel.find({
    _id: {
      $in: productIds,
    },
  }).select("name price mrp stock category_id");

  const productMap = new Map(
    products.map((product) => [String(product._id), product]),
  );

  for (let attempt = 0; attempt < 3; attempt += 1) {
    const cart = await getOrCreateCart(userId);

    for (const item of items) {
      const product = productMap.get(item.productId);

      if (!product) {
        throw createError(`Product not found: ${item.productId}`, 404);
      }

      const existingCartItem = findCartItem(cart, {
        productId: item.productId,
        variantKey: item.variantKey,
      });

      const currentQuantity = existingCartItem?.quantity || 0;

      const nextQuantity = currentQuantity + item.quantity;

      if (product.stock < nextQuantity) {
        throw createError(
          `${product.name} has only ${product.stock} item(s) in stock`,
          400,
        );
      }

      const productPrice = Number(product.price) || 0;
      const productMrp = Number(product.mrp ?? product.price) || productPrice;

      if (existingCartItem) {
        existingCartItem.quantity = nextQuantity;

        existingCartItem.price = productPrice;

        existingCartItem.mrp = productMrp;
      } else {
        cart.items.push({
          product: product._id,
          quantity: item.quantity,
          selectedVariants: item.selectedVariants,
          variantKey: item.variantKey,
          price: productPrice,
          mrp: productMrp,
        });
      }
    }

    try {
      await cart.save();
      return populateCart(cart);
    } catch (error) {
      if (error.name !== "VersionError" || attempt === 2) throw error;
    }
  }

  throw createError("Cart was updated concurrently. Please try again", 409);
};

/* -------------------------------------------------------------------------- */
/*                             Add Multiple Items                             */
/* -------------------------------------------------------------------------- */

export const addToCart = async (req, res) => {
  try {
    assertCustomerCanPurchase(req.user);

    const cart = await addItemsToCart(req.user.id, req.body.items);

    return res.status(200).json({
      success: true,
      message: "Items added successfully",
      data: cart,
    });
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};

/* -------------------------------------------------------------------------- */
/*                              Add Single Item                               */
/* -------------------------------------------------------------------------- */

export const singleProduct = async (req, res) => {
  try {
    assertCustomerCanPurchase(req.user);

    const productId = req.body.productId || req.body.product;

    if (!productId) {
      throw createError("ProductId is required", 400);
    }

    const cart = await addItemsToCart(req.user.id, [
      {
        productId,
        quantity: req.body.quantity ?? req.body.qty ?? 1,
        selectedVariants: req.body.selectedVariants,
      },
    ]);

    return res.status(200).json({
      success: true,
      message: "Product added successfully",
      data: cart,
    });
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};

/* -------------------------------------------------------------------------- */
/*                         Shared Quantity Service                            */
/* -------------------------------------------------------------------------- */

const changeCartItemQuantity = async ({ userId, body, newQuantity }) => {
  const quantity = normalizeQuantity(newQuantity);

  const cart = await cartModel.findOne({
    user: userId,
  });

  if (!cart) {
    throw createError("Cart not found", 404);
  }

  const cartItem = findCartItemFromRequest(cart, body);

  if (!cartItem) {
    throw createError("Product not found in cart", 404);
  }

  const product = await ProductModel.findById(cartItem.product).select(
    "name price mrp stock",
  );

  if (!product) {
    throw createError("Product not found", 404);
  }

  if (product.stock < quantity) {
    throw createError(
      `${product.name} has only ${product.stock} item(s) in stock`,
      400,
    );
  }

  cartItem.quantity = quantity;

  /*
   * Refresh prices from the database whenever
   * cart quantity is updated.
   */
  cartItem.price = Number(product.price) || 0;

  cartItem.mrp = Number(product.mrp ?? product.price) || cartItem.price;

  await cart.save();

  return populateCart(cart);
};

/* -------------------------------------------------------------------------- */
/*                           Set Exact Quantity                               */
/* -------------------------------------------------------------------------- */

export const updateQuantity = async (req, res) => {
  try {
    assertCustomerCanPurchase(req.user);

    const quantity = normalizeQuantity(req.body.quantity ?? req.body.qty);

    const cart = await changeCartItemQuantity({
      userId: req.user.id,
      body: req.body,
      newQuantity: quantity,
    });

    return res.status(200).json({
      success: true,
      message: "Quantity updated successfully",
      data: cart,
    });
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};

/* -------------------------------------------------------------------------- */
/*                            Increment Quantity                              */
/* -------------------------------------------------------------------------- */

export const incrementQuantity = async (req, res) => {
  try {
    assertCustomerCanPurchase(req.user);

    const cart = await cartModel.findOne({
      user: req.user.id,
    });

    if (!cart) {
      throw createError("Cart not found", 404);
    }

    const cartItem = findCartItemFromRequest(cart, req.body);

    if (!cartItem) {
      throw createError("Product not found in cart", 404);
    }

    const nextQuantity = cartItem.quantity + 1;

    const product = await ProductModel.findById(cartItem.product).select(
      "name price mrp stock",
    );

    if (!product) {
      throw createError("Product not found", 404);
    }

    if (product.stock < nextQuantity) {
      throw createError(
        `${product.name} has only ${product.stock} item(s) in stock`,
        400,
      );
    }

    cartItem.quantity = nextQuantity;
    cartItem.price = Number(product.price) || 0;

    cartItem.mrp = Number(product.mrp ?? product.price) || cartItem.price;

    await cart.save();

    return res.status(200).json({
      success: true,
      message: "Quantity incremented successfully",
      data: await populateCart(cart),
    });
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};

/* -------------------------------------------------------------------------- */
/*                            Decrement Quantity                              */
/* -------------------------------------------------------------------------- */

export const decrementQuantity = async (req, res) => {
  try {
    assertCustomerCanPurchase(req.user);

    const cart = await cartModel.findOne({
      user: req.user.id,
    });

    if (!cart) {
      throw createError("Cart not found", 404);
    }

    const cartItem = findCartItemFromRequest(cart, req.body);

    if (!cartItem) {
      throw createError("Product not found in cart", 404);
    }

    if (cartItem.quantity <= 1) {
      throw createError("Quantity can't be less than 1", 400);
    }

    cartItem.quantity -= 1;

    await cart.save();

    return res.status(200).json({
      success: true,
      message: "Quantity decremented successfully",
      data: await populateCart(cart),
    });
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};

/* -------------------------------------------------------------------------- */
/*                                 Get Cart                                   */
/* -------------------------------------------------------------------------- */

export const getCart = async (req, res) => {
  try {
    const userId = req.user.id;

    const cart = await cartModel
      .findOne({
        user: userId,
      })
      .populate({
        path: "items.product",
        populate: {
          path: "category_id",
          select: "name",
        },
      });

    if (!cart) {
      return res.status(200).json({
        success: true,
        message: "Cart is empty",
        data: {
          user: userId,
          items: [],
        },
      });
    }

    return res.status(200).json({
      success: true,
      message:
        cart.items.length === 0 ? "Cart is empty" : "Cart found successfully",
      data: cart,
    });
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};

/* -------------------------------------------------------------------------- */
/*                           Delete Cart Product                              */
/* -------------------------------------------------------------------------- */

export const deleteCartProduct = async (req, res) => {
  try {
    assertCustomerCanPurchase(req.user);

    const cart = await cartModel.findOne({
      user: req.user.id,
    });

    if (!cart) {
      throw createError("Cart not found", 404);
    }

    const cartItem = findCartItemFromRequest(cart, req.body);

    if (!cartItem) {
      throw createError("Product not found in cart", 404);
    }

    cart.items.pull(cartItem._id);

    await cart.save();

    return res.status(200).json({
      success: true,
      message: "Product deleted successfully",
      data: await populateCart(cart),
    });
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};

/* -------------------------------------------------------------------------- */
/*                               Clear Cart                                   */
/* -------------------------------------------------------------------------- */

export const clearCart = async (req, res) => {
  try {
    assertCustomerCanPurchase(req.user);

    const cart = await cartModel.findOneAndUpdate(
      {
        user: req.user.id,
      },
      {
        $set: {
          items: [],
        },
      },
      {
        new: true,
        runValidators: true,
      },
    );

    if (!cart) {
      return res.status(200).json({
        success: true,
        message: "Cart is already empty",
        data: {
          user: req.user.id,
          items: [],
        },
      });
    }

    return res.status(200).json({
      success: true,
      message: "Cart cleared successfully",
      data: await populateCart(cart),
    });
  } catch (error) {
    return sendErrorResponse(res, error);
  }
};
