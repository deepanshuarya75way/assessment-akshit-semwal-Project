import crypto from "node:crypto";
import jwt from "jsonwebtoken";

const requireSecret = (name) => {
  const value = process.env[name];
  if (!value) throw new Error(`Missing ${name} environment variable`);
  return value;
};

export const generateAccessToken = (id, role, tokenVersion = 0) =>
  jwt.sign({ id, role, tokenVersion }, requireSecret("acess_token"), {
    expiresIn: "15m",
  });

export const generateRefreshToken = (id, role, tokenVersion = 0) =>
  jwt.sign(
    { id, role, tokenVersion },
    requireSecret("refresh_token"),
    {
      expiresIn: "7d",
      jwtid: crypto.randomUUID(),
    },
  );

export const hashToken = (value) =>
  crypto.createHash("sha256").update(String(value)).digest("hex");

export default { generateAccessToken, generateRefreshToken, hashToken };
