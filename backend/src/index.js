import express from "express";
import dotenv from "dotenv";
import cros from "cors";

import db from "./database/mongo.db.js";
import adminRouter from "./admin/admin.routes.js";
import userRouter from "./user/user.routes.js";
import { getCorsOptions } from "./config/http.config.js";
import {
  errorHandler,
  notFoundHandler,
} from "./middlewares/error.middleware.js";

dotenv.config();

await db();

const app = express();

app.disable("x-powered-by");
app.use(express.json({ limit: "1mb" }));
app.use(
  cros(getCorsOptions()),
);

// home route
app.get("/", (req, res) => {
  res.send("Welcome to the E-commerce astro");
});

app.use("/uploads", express.static("uploads"));

app.use("/api/v1", adminRouter);
app.use("/api/v1", userRouter);
app.use(notFoundHandler);
app.use(errorHandler);

app.listen(process.env.port, () =>
  console.log(`Server is running on port ${process.env.port}`),
);
