export const getCorsOptions = () => {
  const configuredOrigins = String(process.env.CORS_ORIGINS || "")
    .split(",")
    .map((origin) => origin.trim())
    .filter(Boolean);

  return {
    origin:
      configuredOrigins.length > 0
        ? (origin, callback) => {
            const allowed = configuredOrigins.includes(origin) || !origin;
            return callback(
              allowed ? null : new Error("Origin is not allowed by CORS"),
              allowed,
            );
          }
        : process.env.NODE_ENV === "production"
          ? false
          : "*",
  };
};
