# GameENGINE e-commerce backend

Node.js, Express 5, MongoDB/Mongoose e-commerce API with customer and Admin surfaces. Features include registration and email verification, JWT access/refresh sessions, profiles, catalog, cart, wishlist, coupons, orders, Razorpay checkout, returns, reviews, inventory, banners, homepage settings, referrals, analytics, audit logs, and local/Cloudinary/S3 image storage.

## Requirements and installation

- Node.js 22 or another release compatible with the versions in `package-lock.json`
- MongoDB 8-compatible deployment. Razorpay verification transactions require a replica set or Atlas.
- Optional SMTP, Cloudinary, S3, and Razorpay sandbox accounts

```powershell
npm ci
Copy-Item .env.example .env
npm run dev
```

Production-style start:

```powershell
npm start
```

The default API root is `http://localhost:3000/api/v1`. `port` controls the listener. MongoDB uses `mango_url` (the spelling is retained for compatibility).

## Environment setup

Copy `.env.example`, replace placeholders, and never commit `.env`. See [ENVIRONMENT_VARIABLES.md](./ENVIRONMENT_VARIABLES.md). Use long independent values for `acess_token`, `refresh_token`, and `SECRET_KEY`. The legacy spellings are part of the current deployment contract.

Image storage is selected with `IMAGE_STORAGE_PROVIDER=local|cloudinary|s3`. Local images are written to `uploads/`; Cloudinary and S3 require their corresponding variables. Uploads are held in memory, restricted to one image of at most 5 MB, MIME-filtered, decoded by Sharp, resized per feature, and stored as WebP.

Email uses SMTP variables and HTML templates under `src/templates`. Razorpay requires test credentials for local testing; never run automated tests with production credentials.

## Database and execution

MongoDB connects before the HTTP listener starts. A failed connection exits the process. For a local database:

```env
mango_url=mongodb://127.0.0.1:27017/ecommerce
```

Tests use MongoDB Memory Server and mock SMTP. On this machine the cached binary can be selected with `MONGOMS_SYSTEM_BINARY`; see [API_TEST_REPORT.md](./API_TEST_REPORT.md).

```powershell
npm test
npm test -- --coverage
```

## Source layout

```text
src/
  admin/          Admin routes, controllers, role middleware
  user/           Customer/public routes and controllers
  models/         21 Mongoose models
  services/       Shared business logic
  middlewares/    Authentication, upload, and final error handling
  storage/        Local, Cloudinary, and S3 adapters
  config/         Storage configuration
  database/       MongoDB connection
  templates/      Verification and password-reset email HTML
  utils/          Tokens, passwords, email, coupons, audit helpers
tests/            Jest, Supertest, MongoDB Memory Server
docs/             API, security, schema, test, OpenAPI, Postman docs
```

## Authentication overview

Register, verify email, log in, and send `Authorization: Bearer <access_token>` to protected APIs. Access tokens expire after 15 minutes. Refresh tokens expire after seven days, are stored only as SHA-256 hashes, rotate atomically, and trigger family-wide account token invalidation on reuse. Logout increments the user's token version and invalidates outstanding access/refresh tokens.

Admin APIs accept `admin` and `superAdmin`; order administration also accepts `orderManager`. Customer purchasing APIs reject administrative roles.

## Documentation and troubleshooting

- [API documentation](./API_DOCUMENTATION.md)
- [Endpoint summary](./API_ENDPOINT_SUMMARY.md)
- [OpenAPI](./openapi.yaml)
- [Authentication flow](./AUTHENTICATION_FLOW.md)
- [Database schema](./DATABASE_SCHEMA.md)
- [Postman collection](./postman/ecommerce-backend.postman_collection.json)

Common issues:

- MongoDB startup failure: verify `mango_url`, network access, and replica-set requirements for payment transactions.
- `401`: token is missing, malformed, expired, rotated, or logged out.
- `403`: account is blocked/unverified or role lacks permission.
- `413`: image exceeds 5 MB.
- Image provider errors: verify the selected provider's variables and delivery permissions.
- SMTP errors: verify host, port, TLS mode, username, and application password.

No Nginx configuration is required or included.
