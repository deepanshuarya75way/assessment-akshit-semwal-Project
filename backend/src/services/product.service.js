import Product from "../models/product.model.js";
import productModel from "../models/product.model.js";
import ReviewModel from "../models/review.model.js";
import CategoryModel from "../models/Category.model.js";
import mongoose from "mongoose";
import { deleteImageAsset, saveImageAsset } from "../utils/image-upload.js";

const attachReviewSummary = async (products) => {
  const productList = Array.isArray(products) ? products : [products];
  const ids = productList
    .filter(Boolean)
    .map((product) => product._id);

  if (ids.length === 0) return Array.isArray(products) ? [] : null;

  const summaries = await ReviewModel.aggregate([
    {
      $match: {
        product: { $in: ids },
        status: "published",
      },
    },
    {
      $group: {
        _id: "$product",
        rating: { $avg: "$rating" },
        ratingCount: { $sum: 1 },
      },
    },
  ]);

  const summaryByProduct = new Map(
    summaries.map((summary) => [
      String(summary._id),
      {
        rating: Number(summary.rating.toFixed(1)),
        ratingCount: summary.ratingCount,
      },
    ]),
  );

  const enrichedProducts = productList.map((product) => {
    if (!product) return null;

    const data = product.toObject ? product.toObject() : product;
    const summary = summaryByProduct.get(String(data._id)) || {
      rating: 0,
      ratingCount: 0,
    };

    return {
      ...data,
      ...summary,
    };
  });

  return Array.isArray(products) ? enrichedProducts : enrichedProducts[0];
};

export const CreateProduct = async (req, res) => {
  let imageResult;
  try {
    const {
      name,
      description,
      price,
      mrp,
      category_id,
      size,
      brand,
      stock,
      producthightlight,
    } = req.body;

    const missingFields = [];
    if (!name?.trim()) missingFields.push("name");
    if (!description?.trim()) missingFields.push("description");
    if (price === undefined || price === "") missingFields.push("price");
    if (!category_id) missingFields.push("category");
    if (!brand?.trim()) missingFields.push("brand");
    if (!producthightlight?.trim()) missingFields.push("product highlights");
    if (stock === undefined || stock === "") missingFields.push("stock");

    if (missingFields.length > 0) {
      return res.status(400).json({
        message: `Missing required fields: ${missingFields.join(", ")}`,
      });
    }

    if (!req.file) {
      return res.status(400).json({
        message: "Image is required",
      });
    }

    const productPrice = Number(price);
    const productMrp = mrp === undefined || mrp === "" ? productPrice : Number(mrp);
    const productStock = Number(stock);

    if (!Number.isFinite(productPrice) || productPrice < 0) {
      return res.status(400).json({ message: "Price must be 0 or greater" });
    }
    if (!Number.isFinite(productMrp) || productMrp < 0) {
      return res.status(400).json({ message: "MRP must be 0 or greater" });
    }
    if (!Number.isInteger(productStock) || productStock < 0) {
      return res.status(400).json({ message: "Stock must be a non-negative integer" });
    }
    if (!mongoose.Types.ObjectId.isValid(category_id)) {
      return res.status(400).json({ message: "Invalid category id" });
    }
    if (!(await CategoryModel.exists({ _id: category_id }))) {
      return res.status(404).json({ message: "Category not found" });
    }

    imageResult = await saveImageAsset({
      file: req.file,
      folder: "products",
      name,
      width: 500,
      height: 500,
      quality: 80,
    });

    const product = await Product.create({
      name,
      description,
      price: productPrice,
      mrp: Number.isNaN(productMrp) ? productPrice : productMrp,
      category_id,
      size,
      brand,
      producthightlight,
      stock: productStock,

      localimage: imageResult.localimage,

      // Cloudinary
      image: imageResult.image,
      public_id: imageResult.public_id,
      storageProvider: imageResult.storageProvider,
    });

    // product.save();

    if (!product) {
      return res.status(400).json({
        message: "Product not created",
      });
    }

    return res.status(200).json({
      message: "Product created successfully",
      data: product,
    });
  } catch (ex) {
    if (imageResult) {
      await deleteImageAsset({
        publicId: imageResult.public_id,
        localimage: imageResult.localimage,
        storageProvider: imageResult.storageProvider,
      });
    }
    return res.status(ex.status || 500).json({
      message: ex.status ? ex.message : "Unable to create product",
    });
  }
};

export const GetAllProduct = async (req, res) => {
  try {
    const product = await productModel.find().populate("category_id");
    if (!product) {
      return res.status(400).json({
        message: "Product not found",
      });
    }
    return res.status(200).json({
      message: "Product found successfully",
      data: await attachReviewSummary(product),
    });
  } catch (ex) {
    console.log(ex);
    return res.status(ex.status || 500).json({
      message: ex.status ? ex.message : "Unable to fetch products",
    });
  }
};

export const GetProductById = async (req, res) => {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({ message: "Invalid product id" });
    }

    const product = await productModel
      .findById(req.params.id)
      .populate("category_id");
    if (!product) {
      return res.status(404).json({
        message: "Product not found",
      });
    }
    return res.status(200).json({
      message: "Product found successfully",
      data: await attachReviewSummary(product),
    });
  } catch (ex) {
    console.log(ex);
    return res.status(500).json({
      message: "Unable to fetch product",
    });
  }
};

export const GetProductsByCategory = async (req, res) => {
  try {
    const { categoryId } = req.params;
    if (!mongoose.Types.ObjectId.isValid(categoryId)) {
      return res.status(400).json({ success: false, message: "Invalid category id" });
    }
    const products = await Product.find({ category_id: categoryId }).populate("category_id");
    const enrichedProducts = await attachReviewSummary(products);

    return res.status(200).json({
      success: true,
      count: enrichedProducts.length,
      products: enrichedProducts,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Unable to fetch products",
    });
  }
};

// delete

export const DeleteProduct = async (req, res) => {
  try {
    const product = await productModel.findByIdAndDelete(req.params.id);
    if (!product) {
      return res.status(400).json({
        message: "Product not found",
      });
    }

    await deleteImageAsset({
      publicId: product.public_id,
      localimage: product.localimage,
      storageProvider: product.storageProvider,
    });

    return res.status(200).json({
      message: "Product deleted successfully",
      data: product,
    });
  } catch (ex) {
    console.log(ex);
    return res.status(500).json({
      message: "Unable to delete product",
    });
  }
};

// update
export const UpdateProduct = async (req, res) => {
  let imageResult;
  let oldImageAsset;
  try {
    const {
      name,
      description,
      price,
      mrp,
      category_id,
      size,
      brand,
      stock,
      producthightlight,
    } = req.body;

    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({ message: "Invalid product id" });
    }
    const product = await productModel.findById(req.params.id);
    if (!product) {
      return res.status(400).json({
        message: "Product not found",
      });
    }

    if (category_id !== undefined && category_id !== "") {
      if (!mongoose.Types.ObjectId.isValid(category_id)) {
        return res.status(400).json({ message: "Invalid category id" });
      }
      if (!(await CategoryModel.exists({ _id: category_id }))) {
        return res.status(404).json({ message: "Category not found" });
      }
      product.category_id = category_id;
    }
    if (price !== undefined && price !== "" && (!Number.isFinite(Number(price)) || Number(price) < 0)) {
      return res.status(400).json({ message: "Price must be 0 or greater" });
    }
    if (mrp !== undefined && mrp !== "" && (!Number.isFinite(Number(mrp)) || Number(mrp) < 0)) {
      return res.status(400).json({ message: "MRP must be 0 or greater" });
    }
    if (name !== undefined) product.name = name;
    if (size !== undefined) product.size = size;
    if (brand !== undefined) product.brand = brand;
    if (producthightlight !== undefined) product.producthightlight = producthightlight;
    if (description !== undefined) product.description = description;
    if (price !== undefined && price !== "") product.price = Number(price);
    if (mrp !== undefined && mrp !== "") product.mrp = Number(mrp);
    if ((product.mrp === undefined || product.mrp === null) && product.price !== undefined) {
      product.mrp = product.price;
    }
    if (stock !== undefined && stock !== "") {
      const nextStock = Number(stock);
      if (!Number.isInteger(nextStock) || nextStock < 0) {
        return res.status(400).json({ message: "Stock must be a non-negative integer" });
      }
      product.stock = nextStock;
    }

    if (req.file) {
      oldImageAsset = {
        public_id: product.public_id,
        localimage: product.localimage,
        storageProvider: product.storageProvider,
      };
      imageResult = await saveImageAsset({
        file: req.file,
        folder: "products",
        name: name || product.name,
        width: 500,
        height: 500,
        quality: 80,
      });
      product.image = imageResult.image;
      product.localimage = imageResult.localimage;
      product.public_id = imageResult.public_id;
      product.storageProvider = imageResult.storageProvider;
    }

    await product.save();
    if (oldImageAsset) {
      await deleteImageAsset({
        publicId: oldImageAsset.public_id,
        localimage: oldImageAsset.localimage,
        storageProvider: oldImageAsset.storageProvider,
      });
    }
    return res.status(200).json({
      message: "Product updated successfully",
      data: product,
    });
  } catch (ex) {
    if (imageResult) {
      await deleteImageAsset({
        publicId: imageResult.public_id,
        localimage: imageResult.localimage,
        storageProvider: imageResult.storageProvider,
      });
    }
    return res.status(ex.status || 500).json({
      message: ex.status ? ex.message : "Unable to update product",
    });
  }
};
