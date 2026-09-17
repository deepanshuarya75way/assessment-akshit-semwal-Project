import { getShiprocketToken } from "../../services/shiprocket.service.js";

export const testShiprocketConnection = async (req, res) => {
  try {
    const token = await getShiprocketToken();

    return res.status(200).json({
      success: true,
      message: "Shiprocket connected successfully.",
      tokenReceived: Boolean(token),
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
