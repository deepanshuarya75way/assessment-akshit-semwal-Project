import Banner from "../models/Banner.model.js";
import mongoose from "mongoose";
import { deleteImageAsset, saveImageAsset, slugify } from "../utils/image-upload.js";

const toBoolean = (value, fallback = true) => {
  if (value === undefined || value === null || value === "") return fallback;
  if (typeof value === "boolean") return value;
  return String(value).toLowerCase() === "true";
};

const toNumber = (value, fallback = 0) => {
  if (value === undefined || value === null || value === "") return fallback;
  const number = Number(value);
  return Number.isNaN(number) ? fallback : number;
};

const saveBannerImage = async (file, title = "") => {
  const name = slugify(title || "banner");

  return saveImageAsset({
    file,
    folder: "banners",
    name,
    width: 1600,
    height: 600,
    fit: "cover",
    quality: 82,
  });
};

const buildBannerPayload = (body = {}) => {
  const payload = {};
  const fields = [
    "title",
    "titleColor",
    "subtitle",
    "subtitleColor",
    "cta",
    "ctaBg",
    "ctaText",
    "alignment",
    "to",
  ];

  for (const field of fields) {
    if (body[field] !== undefined) payload[field] = body[field];
  }

  if (body.overlayOpacity !== undefined) {
    payload.overlayOpacity = toNumber(body.overlayOpacity, 0);
  }
  if (body.order !== undefined) {
    payload.order = toNumber(body.order, 0);
  }
  if (body.isActive !== undefined) {
    payload.isActive = toBoolean(body.isActive, true);
  }

  return payload;
};

export const CreateBanner = async (req, res) => {
  let imageResult;
  try {
    if (!req.file) {
      return res.status(400).json({ message: "Banner image is required" });
    }

    const payload = buildBannerPayload(req.body);
    imageResult = await saveBannerImage(req.file, payload.title);

    const banner = await Banner.create({
      ...payload,
      bg: imageResult.image,
      public_id: imageResult.public_id,
      localimage: imageResult.localimage,
      storageProvider: imageResult.storageProvider,
    });

    return res.status(201).json({
      message: "Banner created successfully",
      data: banner,
    });
  } catch (error) {
    if (imageResult) {
      await deleteImageAsset({
        publicId: imageResult.public_id,
        localimage: imageResult.localimage,
        storageProvider: imageResult.storageProvider,
      });
    }
    console.error("CreateBanner Error:", error);
    return res.status(error.status || 500).json({
      message: error.status ? error.message : "Unable to create banner",
    });
  }
};

export const GetAllBanners = async (req, res) => {
  try {
    const includeInactive =
      String(req.query.includeInactive || "").toLowerCase() === "true";
    const filter = includeInactive ? {} : { isActive: true };
    const banners = await Banner.find(filter).sort({ order: 1, createdAt: -1 });

    return res.status(200).json({
      message: "Banners fetched successfully",
      data: banners,
    });
  } catch (error) {
    return res.status(error.status || 500).json({
      message: error.status ? error.message : "Unable to fetch banners",
    });
  }
};

export const GetBannerById = async (req, res) => {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({ message: "Invalid banner id" });
    }
    const banner = await Banner.findById(req.params.id);

    if (!banner) {
      return res.status(404).json({ message: "Banner not found" });
    }

    return res.status(200).json({
      message: "Banner fetched successfully",
      data: banner,
    });
  } catch (error) {
    return res.status(500).json({ message: "Unable to fetch banner" });
  }
};

export const UpdateBanner = async (req, res) => {
  let imageResult;
  let oldImageAsset;
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({ message: "Invalid banner id" });
    }
    const banner = await Banner.findById(req.params.id);

    if (!banner) {
      return res.status(404).json({ message: "Banner not found" });
    }

    Object.assign(banner, buildBannerPayload(req.body));

    if (req.file) {
      oldImageAsset = {
        public_id: banner.public_id,
        localimage: banner.localimage,
        storageProvider: banner.storageProvider,
      };
      imageResult = await saveBannerImage(req.file, banner.title);

      banner.bg = imageResult.image;
      banner.public_id = imageResult.public_id;
      banner.localimage = imageResult.localimage;
      banner.storageProvider = imageResult.storageProvider;
    }

    await banner.save();
    if (oldImageAsset) {
      await deleteImageAsset({
        publicId: oldImageAsset.public_id,
        localimage: oldImageAsset.localimage,
        storageProvider: oldImageAsset.storageProvider,
      });
    }

    return res.status(200).json({
      message: "Banner updated successfully",
      data: banner,
    });
  } catch (error) {
    if (imageResult) {
      await deleteImageAsset({
        publicId: imageResult.public_id,
        localimage: imageResult.localimage,
        storageProvider: imageResult.storageProvider,
      });
    }
    console.error("UpdateBanner Error:", error);
    return res.status(error.status || 500).json({
      message: error.status ? error.message : "Unable to update banner",
    });
  }
};

export const DeleteBanner = async (req, res) => {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({ message: "Invalid banner id" });
    }
    const banner = await Banner.findByIdAndDelete(req.params.id);

    if (!banner) {
      return res.status(404).json({ message: "Banner not found" });
    }

    await deleteImageAsset({
      publicId: banner.public_id,
      localimage: banner.localimage,
      storageProvider: banner.storageProvider,
    });

    return res.status(200).json({
      message: "Banner deleted successfully",
    });
  } catch (error) {
    return res.status(500).json({ message: "Unable to delete banner" });
  }
};
