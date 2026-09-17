import {
  generateAccessToken,
  generateRefreshToken,
  hashToken,
} from "../../utils/token.js";
import jwt from "jsonwebtoken";

import bcrypt from "bcrypt";
import crypto from "crypto";

import emailverificationmodel from "../../models/emailverification.model.js";

// import CreateHashPassword from "../../utils/password.js";

// import verfilypass from "../../utils/password.js";
import { CreateharhPassword, VerfiyPaswword } from "../../utils/password.js";

import UserModel from "../../models/User.model.js";
import UserProfile from "../../models/userprofile.model.js";
import {
  sendPasswordResetEmail,
  sendVerificationEmail,
} from "../../utils/email.js";
import {
  CloseLoginActivity,
  CreateLoginActivity,
} from "../../services/login-activity.service.js";

const normalizeEmail = (email = "") => String(email).trim().toLowerCase();

const hashPasswordResetToken = (resetToken) =>
  crypto.createHash("sha256").update(String(resetToken)).digest("hex");

const getPasswordResetTokenTtlMs = () => {
  const configuredMinutes = Number.parseInt(
    process.env.PASSWORD_RESET_TOKEN_TTL_MINUTES,
    10,
  );
  const ttlMinutes =
    Number.isInteger(configuredMinutes) && configuredMinutes > 0
      ? Math.min(configuredMinutes, 1440)
      : 15;

  return ttlMinutes * 60 * 1000;
};

const generateReferralCode = (email) => {
  const prefix = String(email)
    .split("@")[0]
    .replace(/[^a-z0-9]/gi, "")
    .slice(0, 4);
  return `${prefix}${crypto.randomBytes(3).toString("hex")}`.toUpperCase();
};

const escapeRegex = (value = "") =>
  value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

const findUserByEmail = async (email) => {
  const normalizedEmail = normalizeEmail(email);
  if (!normalizedEmail) return null;

  return UserModel.findOne({
    email: { $regex: `^${escapeRegex(normalizedEmail)}$`, $options: "i" },
  });
};

const getProfileDisplayName = (profile) => {
  if (!profile) return "";

  return (
    profile.fullName ||
    [profile.firstName, profile.middleName, profile.lastName]
      .filter(Boolean)
      .join(" ")
      .trim()
  );
};

const verifyStoredPassword = async (password, storedPassword) => {
  if (!password || !storedPassword) return false;

  if (await VerfiyPaswword(password, storedPassword)) return true;

  try {
    return await bcrypt.compare(password, storedPassword);
  } catch {
    return false;
  }
};

export const login = async (req, res) => {
  try {
    const { Email, Password } = req.body;
    const email = normalizeEmail(Email);

    // Validate input
    if (!email || !Password) {
      return res.status(400).json({
        message: "Email and password are required",
      });
    }

    const user = await findUserByEmail(email);

    if (!user) {
      return res.status(400).json({
        message: "User not found",
      });
    }

    if (user.isActive === false) {
      return res.status(403).json({
        message: "Your account is blocked. Please contact support.",
      });
    }

    // Find user by email
    // const { data: user, error } = await supabase
    //   .from("UserModel")
    //   .select("*")
    //   .eq("Email", email)
    //   .single();

    // if (error || !user) {
    //   return res.status(401).json({
    //     message: "User not found in sql",
    //   });
    // }

    // Verify password

    const isPasswordValid = await verifyStoredPassword(Password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({
        message: "Invalid email or password",
      });
    }

    // Generate tokens

    if (user.isVerified === false) {
      return res.status(401).json({
        message: "User not verified",
      });
    }

    const tokenVersion = Number(user.tokenVersion || 0);
    const accessToken = generateAccessToken(user.id, user.role, tokenVersion);
    const refreshToken = generateRefreshToken(user.id, user.role, tokenVersion);
    await UserModel.updateOne(
      { _id: user._id },
      {
        $set: {
          refreshTokenHash: hashToken(refreshToken),
          refreshTokenExpiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        },
      },
    );
    const activity = await CreateLoginActivity(req, user.id);
    const profile = await UserProfile.findOne({ userid: user.id }).select(
      "fullName firstName middleName lastName",
    );
    // const displayName = getProfileDisplayName(profile);

    return res.status(200).json({
      message: "Login successful",
      user: {
        id: user.id,
        email: user.email,

        role: user.role,
      },
      token: {
        accessToken,
        refreshToken,
      },
      activityId: activity?._id || null,
    });
  } catch (ex) {
    console.error(ex);

    return res.status(500).json({
      message: ex.message,
    });
  }
};

export const CreateUser = async (req, res) => {
  try {
    const { Email, Password, referralCode } = req.body;
    const email = normalizeEmail(Email);

    // 1. Validate request
    if (!email || !Password) {
      return res.status(400).json({
        message: "All fields are required",
      });
    }

    // 2. Check if user already exists
    const existingUser = await CheckUser(email);

    if (existingUser) {
      return res.status(400).json({
        message: "User already exists",
      });
    }

    const referrerProfile = referralCode
      ? await UserProfile.findOne({
          referralCode: String(referralCode).trim().toUpperCase(),
        })
      : null;

    if (referralCode && !referrerProfile) {
      return res.status(400).json({ message: "Invalid referral code" });
    }

    // 3. Hash password
    const hashedPassword = await CreateharhPassword(Password);

    // 4. Create user
    const user = await UserModel.create({
      email,
      password: hashedPassword,
      role: "user",
      isActive: true,
      isVerified: false,
    });

    if (!user) {
      return res.status(500).json({
        message: "User creation failed",
      });
    }

    await UserProfile.create({
      userid: user._id,
      referralCode: generateReferralCode(email),
      referredBy: referrerProfile?.userid || null,
    });

    // 5. Generate verification token
    const token = crypto.randomBytes(64).toString("hex");

    // 6. Save verification token
    const emailVerification = await emailverificationmodel.create({
      userId: user._id,
      token: token,
      email,
      isUsed: false,
      createdAt: new Date(),
    });

    if (!emailVerification) {
      return res.status(500).json({
        message: "Failed to create verification token",
      });
    }

    // 7. Verification link
    const verificationLink = `${process.env.FRONTEND_URL || "http://localhost:3000"}/auth/verify-email?token=${token}`;

    // 8. Send verification email
    // await sendEmail(Email, token);

    await sendVerificationEmail(Email, token);

    // 9. Remove password from response
    const { password, ...userData } = user.toObject();

    // 10. Success response
    return res.status(201).json({
      message: "User created successfully. Please verify your email.",
      user: userData,
    });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      message: error.message,
    });
  }
};

export const logout = async (req, res) => {
  try {
    const activityId = req.body?.activityId;
    if (activityId) {
      await CloseLoginActivity(req.user.id, activityId);
    }

    await UserModel.updateOne(
      { _id: req.user.id },
      {
        $inc: { tokenVersion: 1 },
        $unset: { refreshTokenHash: "", refreshTokenExpiresAt: "" },
      },
    );

    return res.status(200).json({
      success: true,
      message: "Logout successful",
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

async function CheckUser(email) {
  try {
    const user = await findUserByEmail(email);

    return user;
  } catch (error) {
    console.log("DB Error:", error);
    return null;
  }
}

export const EmailVerfily = async (req, res) => {
  try {
    const token = req.headers["x-verification-token"];

    if (!token) {
      return res.status(400).json({
        message: "Token is required",
      });
    }

    // Find verification token
    const emailVerification = await emailverificationmodel.findOne({ token });

    if (!emailVerification) {
      return res.status(400).json({
        message: "Invalid token",
      });
    }

    if (emailVerification.isUsed) {
      return res.status(400).json({
        message: "Email already verified",
      });
    }

    // Update user
    const user = await UserModel.findByIdAndUpdate(
      emailVerification.userId,
      {
        isVerified: true,
        isActive: true,
      },
      { new: true },
    );

    if (!user) {
      return res.status(404).json({
        message: "User not found",
      });
    }

    // Mark token as used
    await emailverificationmodel.findByIdAndUpdate(emailVerification._id, {
      isUsed: true,
      token: null,
    });

    return res.status(200).json({
      message: "Email verified successfully",
    });
  } catch (error) {
    console.log(error);

    return res.status(500).json({
      message: error.message,
    });
  }
};

export const ForgetPassword = async (req, res) => {
  try {
    const email = normalizeEmail(req.body?.email);

    if (!email) {
      return res.status(400).json({
        message: "Email is required",
      });
    }

    const user = await findUserByEmail(email);

    if (!user) {
      return res.status(404).json({
        message: "User not found",
      });
    }

    const resetToken = crypto.randomBytes(64).toString("hex");
    const passwordResetTokenHash = hashPasswordResetToken(resetToken);
    const passwordResetTokenExpiresAt = new Date(
      Date.now() + getPasswordResetTokenTtlMs(),
    );

    // Use the native collection update so any legacy plaintext token is
    // removed even after the old Resettoken path is removed from the schema.
    await UserModel.collection.updateOne(
      { _id: user._id },
      {
        $set: {
          passwordResetTokenHash,
          passwordResetTokenExpiresAt,
        },
        $unset: { Resettoken: "" },
      },
    );

    await sendPasswordResetEmail(user.email, resetToken);

    console.log(`Password reset email sent to ${resetToken}`);

    return res.status(200).json({
      message: "Password reset email sent successfully.",
    });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      message: error.message,
    });
  }
};
export const ResetPassword = async (req, res) => {
  try {
    const { resetToken, password } = req.body;

    // Validate request
    if (!resetToken || !password) {
      return res.status(400).json({
        message: "All fields are required",
      });
    }

    const hashedPassword = await CreateharhPassword(password);
    const passwordResetTokenHash = hashPasswordResetToken(resetToken);

    // Matching and clearing in one database operation prevents the same
    // one-time token from succeeding in two concurrent requests.
    const user = await UserModel.findOneAndUpdate(
      {
        passwordResetTokenHash,
        passwordResetTokenExpiresAt: { $gt: new Date() },
      },
      {
        $set: { password: hashedPassword },
        $unset: {
          passwordResetTokenHash: "",
          passwordResetTokenExpiresAt: "",
          Resettoken: "",
        },
      },
      { returnDocument: "after" },
    );

    if (!user) {
      return res.status(404).json({
        message: "Invalid or expired reset token",
      });
    }

    return res.status(200).json({
      message: "Password reset successfully.",
    });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      message: error.message,
    });
  }
};

export const RefreshToken = async (req, res) => {
  try {
    const refreshToken =
      req.body?.refreshToken || req.headers["x-refresh-token"];

    if (!refreshToken) {
      return res.status(400).json({
        success: false,
        message: "Refresh token is required",
      });
    }

    // Verify refresh token
    const decoded = jwt.verify(refreshToken, process.env.refresh_token);

    if (!decoded?.id) {
      return res.status(401).json({
        success: false,
        message: "Invalid refresh token",
      });
    }

    const tokenVersion = Number(decoded.tokenVersion ?? 0);
    const presentedHash = hashToken(refreshToken);

    // Get user with hidden token fields
    const account = await UserModel.findById(decoded.id).select(
      "+refreshTokenHash +refreshTokenExpiresAt role isActive isVerified tokenVersion",
    );

    if (!account) {
      return res.status(401).json({
        success: false,
        message: "Invalid refresh token",
      });
    }

    const accountTokenVersion = Number(account.tokenVersion ?? 0);

    console.log({
      userId: account._id.toString(),
      hashMatches: account.refreshTokenHash === presentedHash,
      tokenVersionFromToken: tokenVersion,
      tokenVersionFromDatabase: accountTokenVersion,
      isActive: account.isActive,
      isVerified: account.isVerified,
    });

    // Validate user account
    if (
      account.isActive === false ||
      account.isVerified === false ||
      accountTokenVersion !== tokenVersion
    ) {
      return res.status(401).json({
        success: false,
        message: "Invalid refresh token",
      });
    }

    // Token must exist in database
    if (!account.refreshTokenHash) {
      return res.status(401).json({
        success: false,
        message: "No active refresh token. Please login again.",
      });
    }

    // Check database expiry
    if (
      !account.refreshTokenExpiresAt ||
      account.refreshTokenExpiresAt.getTime() <= Date.now()
    ) {
      await UserModel.updateOne(
        { _id: account._id },
        {
          $unset: {
            refreshTokenHash: "",
            refreshTokenExpiresAt: "",
          },
        },
      );

      return res.status(401).json({
        success: false,
        message: "Refresh token expired. Please login again.",
      });
    }

    // Detect token reuse
    if (account.refreshTokenHash !== presentedHash) {
      await UserModel.updateOne(
        {
          _id: account._id,
          tokenVersion: accountTokenVersion,
        },
        {
          $inc: {
            tokenVersion: 1,
          },
          $unset: {
            refreshTokenHash: "",
            refreshTokenExpiresAt: "",
          },
        },
      );

      return res.status(401).json({
        success: false,
        message: "Refresh token reuse detected. Please login again.",
      });
    }

    // Generate new tokens
    const newAccessToken = generateAccessToken(
      account._id.toString(),
      account.role,
      accountTokenVersion,
    );

    const newRefreshToken = generateRefreshToken(
      account._id.toString(),
      account.role,
      accountTokenVersion,
    );

    const newRefreshTokenHash = hashToken(newRefreshToken);

    /*
      Atomic refresh-token rotation.

      This update succeeds only when:
      - user still exists
      - token version is still the same
      - old refresh token hash is still stored
      - account is active and verified
    */
    const rotated = await UserModel.findOneAndUpdate(
      {
        _id: account._id,
        tokenVersion: accountTokenVersion,
        refreshTokenHash: presentedHash,
        isActive: { $ne: false },
        isVerified: { $ne: false },
        refreshTokenExpiresAt: {
          $gt: new Date(),
        },
      },
      {
        $set: {
          refreshTokenHash: newRefreshTokenHash,
          refreshTokenExpiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        },
      },
      {
        new: true,
      },
    );

    console.log(rotated);

    if (!rotated) {
      return res.status(401).json({
        success: false,
        message:
          "Refresh token was already used. Use the latest refresh token.",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Token refreshed successfully",
      token: {
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      },
    });
  } catch (error) {
    console.error("Refresh token error:", {
      name: error.name,
      message: error.message,
    });

    if (error.name === "TokenExpiredError") {
      return res.status(401).json({
        success: false,
        message: "Refresh token expired. Please login again.",
      });
    }

    if (error.name === "JsonWebTokenError") {
      return res.status(401).json({
        success: false,
        message: "Invalid refresh token",
      });
    }

    return res.status(500).json({
      success: false,
      message: "Unable to refresh token",
    });
  }
};

export const GoogleLogin = async (req, res) => {
  try {
    const profile = await verifyGoogleCredential(req.body?.credential);
    if (!profile.email) {
      return res
        .status(400)
        .json({ message: "Google account email was not provided" });
    }

    let user = await findUserByEmail(profile.email);
    if (user?.isBlocked === true) {
      return res.status(403).json({
        message: "Your account is blocked. Please contact support.",
      });
    }

    if (!user) {
      const randomPassword = await CreateharhPassword(
        `google:${profile.googleId}:${crypto.randomBytes(24).toString("hex")}`,
      );
      user = await UserModel.create({
        email: profile.email,
        password: randomPassword,
        role: "user",
        isActive: true,
        isBlocked: false,
        isVerified: true,
      });
    } else {
      user.isActive = true;
      user.isVerified = true;
      await user.save();
    }

    const existingProfile = await UserProfile.findOne({ userid: user._id });
    if (!existingProfile) {
      await UserProfile.create({
        userid: user._id,
        referralCode: `ASTRO-${Math.random().toString(36).substring(2, 8).toUpperCase()}`,
        fullName: profile.name,
        firstName: profile.firstName,
        lastName: profile.lastName,
        avatar: profile.avatar,
      });
    } else {
      if (profile.name && !existingProfile.fullName)
        existingProfile.fullName = profile.name;
      if (profile.firstName && !existingProfile.firstName)
        existingProfile.firstName = profile.firstName;
      if (profile.lastName && !existingProfile.lastName)
        existingProfile.lastName = profile.lastName;
      if (profile.avatar && !existingProfile.avatar)
        existingProfile.avatar = profile.avatar;
      await existingProfile.save();
    }

    return buildLoginResponse(req, res, user);
  } catch (error) {
    return res.status(401).json({
      message: error.message || "Google login failed",
    });
  }
};

const verifyGoogleCredential = async (credential) => {
  const clientId = process.env.GOOGLE_CLIENT_ID;
  if (!clientId) {
    throw new Error("Google login is not configured on the server");
  }

  const parts = String(credential || "").split(".");
  if (parts.length !== 3) throw new Error("Invalid Google credential");

  const [encodedHeader, encodedPayload, encodedSignature] = parts;
  const header = decodeJwtPart(encodedHeader);
  const payload = decodeJwtPart(encodedPayload);

  if (header.alg !== "RS256" || !header.kid) {
    throw new Error("Invalid Google token header");
  }

  const certs = await getGoogleCerts();
  const cert = certs[header.kid];
  if (!cert) throw new Error("Google certificate not found for this token");

  const verifier = createVerify("RSA-SHA256");
  verifier.update(`${encodedHeader}.${encodedPayload}`);
  verifier.end();

  const isValidSignature = verifier.verify(
    cert,
    base64UrlToBuffer(encodedSignature),
  );
  if (!isValidSignature) throw new Error("Invalid Google token signature");

  if (!GOOGLE_ISSUERS.has(payload.iss))
    throw new Error("Invalid Google token issuer");
  if (payload.aud !== clientId)
    throw new Error("Invalid Google token audience");
  if (!payload.exp || payload.exp * 1000 <= Date.now()) {
    throw new Error("Google token has expired");
  }
  if (payload.email_verified !== true) {
    throw new Error("Google account email is not verified");
  }

  return {
    email: normalizeEmail(payload.email),
    name: String(payload.name || "").trim(),
    firstName: String(payload.given_name || "").trim(),
    lastName: String(payload.family_name || "").trim(),
    avatar: String(payload.picture || "").trim(),
    googleId: String(payload.sub || "").trim(),
  };
};
