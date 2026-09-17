# Authentication flow

## Registration and verification

`POST /api/v1/user/auth/create` normalizes the email, ignores a caller-supplied role, hashes the password with the configured HMAC pepper and bcrypt, creates a User profile/referral code, stores a one-hour email-verification token, and sends the token by SMTP. `POST /email-verify` receives it in `x-verification-token`, marks the user verified/active, and makes the token unusable.

```mermaid
sequenceDiagram
  participant C as Client
  participant A as API
  participant M as MongoDB
  participant S as SMTP
  C->>A: Register (Email, Password)
  A->>M: Create user, profile, verification token
  A->>S: Send verification link
  C->>A: x-verification-token
  A->>M: Mark verified; consume token
  A-->>C: Verification successful
```

## Login, access, refresh, and logout

Login requires an active, verified account and returns a 15-minute access token, a seven-day refresh token, and optional login-activity ID. Only a SHA-256 hash and expiry of the refresh token are stored. Protected middleware verifies signature/expiry and reloads role, active state, verification state, and `tokenVersion` from MongoDB.

Refresh accepts `POST` JSON (`refreshToken`) or the legacy GET method with `x-refresh-token`. Query-string tokens are not accepted. An atomic compare-and-replace rotates the stored hash, so one of multiple simultaneous uses wins. A later replay invalidates the account's outstanding token version. Logout closes the optional login activity, increments `tokenVersion`, and removes the refresh hash.

```mermaid
sequenceDiagram
  participant C as Client
  participant A as API
  participant M as MongoDB
  C->>A: Login credentials
  A->>M: Validate active, verified user
  A->>M: Store refresh-token hash and expiry
  A-->>C: Access token + refresh token
  C->>A: Protected request + Bearer token
  A->>M: Check current role/state/tokenVersion
  A-->>C: Resource
  C->>A: Refresh token
  A->>M: Atomic hash rotation
  A-->>C: New access + refresh tokens
  C->>A: Logout + access token
  A->>M: Increment tokenVersion; remove refresh hash
```

Password reset tokens are random, stored as SHA-256 hashes with a configurable expiry, and consumed atomically once. The current forgot-password response still distinguishes unknown accounts; changing it is a documented compatibility-sensitive recommendation.

Admin authorization reloads the database role. `admin` and `superAdmin` can use general Admin APIs; `orderManager` is restricted to order-management middleware. Blocked or unverified accounts receive `403`; missing, invalid, expired, rotated, or logged-out tokens receive `401`.
