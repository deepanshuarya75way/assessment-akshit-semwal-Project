import multer from "multer";

export const notFoundHandler = (req, res) =>
  res.status(404).json({ success: false, message: "Route not found" });

export const errorHandler = (error, req, res, next) => {
  if (res.headersSent) return next(error);

  if (error instanceof multer.MulterError) {
    const status = error.code === "LIMIT_FILE_SIZE" ? 413 : 400;
    return res.status(status).json({
      success: false,
      message:
        error.code === "LIMIT_FILE_SIZE"
          ? "Image must be 5 MB or smaller"
          : error.message,
    });
  }

  const status = Number(error.status || error.statusCode) || 500;
  return res.status(status).json({
    success: false,
    message: status >= 500 ? "Internal server error" : error.message,
  });
};
