import catmodel from "../models/Category.model.js";
import ProductModel from "../models/product.model.js";
import mongoose from "mongoose";
import { deleteImageAsset, saveImageAsset } from "../utils/image-upload.js";

export const CreateCategory = async (req, res) => {
  let imageResult;
  try {
    const { name, tagline, themecolor } = req.body || {};

    if (!name || !tagline || !themecolor) {
      return res.status(400).json({
        message: "All fields are required",
      });
    }

    if (!req.file) {
      return res.status(400).json({
        message: "Image is required",
      });
    }
    imageResult = await saveImageAsset({
      file: req.file,
      folder: "categories",
      name,
      width: 500,
      height: 500,
      quality: 80,
    });

    const category = await catmodel.create({
      name: name,
      tagline: tagline,
      themecolor: themecolor,
      image: imageResult.image,
      localimage: imageResult.localimage,
      public_id: imageResult.public_id,
      storageProvider: imageResult.storageProvider,
    });

    if (category) {
      return res.status(201).json({
        message: "Category created successfully",
        sucess: true,
      });
    } else {
      return res.status(400).json({
        message: "Category not created",
        sucess: false,
      });
    }
  } catch (error) {
    if (imageResult) {
      await deleteImageAsset({
        publicId: imageResult.public_id,
        localimage: imageResult.localimage,
        storageProvider: imageResult.storageProvider,
      });
    }
    res.status(error.status || 500).json({
      message: error.status ? error.message : "Unable to create category",
    });
  }
};

/// get all category

export const GetAllCategory = async (req, res) => {
  try {
    const cate = await catmodel.find();

    if (cate.length === 0) {
      return res.status(200).json({
        message: "No categories found",
        data: [],
        sucess: true,
      });
    }

    return res.status(200).json({
      message: "Categories fetched successfully",
      data: cate,
      sucess: true,
    });

    if (!cate) {
      return res.status(400).json({
        message: "something went wrong",
        sucess: false,
      });
    }
  } catch (ex) {
    console.log(ex);

    return res.status(ex.status || 500).json({
      message: ex.status ? ex.message : "Unable to fetch categories",
      sucess: false,
    });
  }
};

export const UpdateCategory = async (req, res) => {
  let imageResult;
  let oldImageAsset;
  try {
    const cateid = req.params.categoryId;
    const { name, tagline, themecolor } = req.body || {};

    // if (!name || !tagline || !themecolor) {
    //   return res.status(400).json({
    //     message: "All fields are required",
    //   });
    // }

    if (!mongoose.Types.ObjectId.isValid(cateid)) {
      return res.status(400).json({
        message: "Invalid category id",
      });
    }

    const category = await catmodel.findById(cateid);
    if (!category) {
      return res.status(404).json({ message: "Category not found", sucess: false });
    }

    if (name !== undefined) category.name = name;
    if (tagline !== undefined) category.tagline = tagline;
    if (themecolor !== undefined) category.themecolor = themecolor;

    if (req.file) {
      oldImageAsset = {
        public_id: category.public_id,
        localimage: category.localimage,
        storageProvider: category.storageProvider,
      };
      imageResult = await saveImageAsset({
        file: req.file,
        folder: "categories",
        name: name || category.name,
        width: 500,
        height: 500,
        quality: 80,
      });

      category.image = imageResult.image;
      category.localimage = imageResult.localimage;
      category.public_id = imageResult.public_id;
      category.storageProvider = imageResult.storageProvider;
    }

    await category.save();
    if (oldImageAsset) {
      await deleteImageAsset({
        publicId: oldImageAsset.public_id,
        localimage: oldImageAsset.localimage,
        storageProvider: oldImageAsset.storageProvider,
      });
    }

    return res.status(200).json({
      message: "Category updated successfully",
      sucess: true,
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
      message: ex.status ? ex.message : "Unable to update category",
      sucess: false,
    });
  }
};

// delete

export const DeleteCategory = async (req, res) => {
  try {
    const cateid = req.params.categoryId;
    if (!mongoose.Types.ObjectId.isValid(cateid)) {
      return res.status(400).json({ message: "Invalid category id", sucess: false });
    }
    if (await ProductModel.exists({ category_id: cateid })) {
      return res.status(409).json({
        message: "Category cannot be deleted while products still reference it",
        sucess: false,
      });
    }
    const cate = await catmodel.findByIdAndDelete(cateid);
    if (cate) {
      await deleteImageAsset({
        publicId: cate.public_id,
        localimage: cate.localimage,
        storageProvider: cate.storageProvider,
      });

      return res.status(200).json({
        message: "Category deleted successfully",
        sucess: true,
      });
    }
    return res.status(400).json({
      message: "Category not deleted",
      sucess: false,
    });
  } catch (ex) {
    console.log(ex);
    return res.status(500).json({
      message: "Unable to delete category",
      sucess: false,
    });
  }
};
