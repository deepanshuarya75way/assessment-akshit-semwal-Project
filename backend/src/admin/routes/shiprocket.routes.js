import express from "express";
import { testShiprocketConnection } from "../controllers/shiprocket.controller.js";

const router = express.Router();

router.get("/test-connection", testShiprocketConnection);

export default router;
