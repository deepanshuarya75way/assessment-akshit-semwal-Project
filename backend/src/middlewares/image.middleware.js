import multer from "multer";

const storage = multer.memoryStorage();
const MAX_IMAGE_SIZE_BYTES = 5 * 1024 * 1024;
const ALLOWED_IMAGE_TYPES = new Set([
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/gif",
  "image/avif",
]);

export const upload = multer({
  storage,
  limits: { fileSize: MAX_IMAGE_SIZE_BYTES, files: 1 },
  fileFilter: (req, file, callback) => {
    if (!ALLOWED_IMAGE_TYPES.has(file.mimetype)) {
      const error = new Error("Only JPEG, PNG, WebP, GIF, or AVIF images are allowed");
      error.status = 400;
      return callback(error);
    }
    return callback(null, true);
  },
});

export default upload;
