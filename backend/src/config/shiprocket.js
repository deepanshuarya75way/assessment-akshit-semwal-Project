import axios from "axios";

export const shiprocketApi = axios.create({
  baseURL: "https://apiv2.shiprocket.in/v1/external",
  timeout: 15000,
  headers: {
    "Content-Type": "application/json",
  },
});
