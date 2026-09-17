import express from "express";
import cors from "cors";
import {
  errorHandler,
  notFoundHandler,
} from "../src/middlewares/error.middleware.js";

export const createTestApp = async () => {
  const { default: adminRouter } = await import("../src/admin/admin.routes.js");
  const { default: userRouter } = await import("../src/user/user.routes.js");

  const app = express();
  app.disable("x-powered-by");
  app.use(express.json({ limit: "1mb" }));
  app.use(cors({ origin: "*" }));
  app.use("/api/v1", adminRouter);
  app.use("/api/v1", userRouter);
  app.use(notFoundHandler);
  app.use(errorHandler);
  return app;
};
