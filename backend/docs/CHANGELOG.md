# Task changelog

## 2026-07-16 backend audit

### Security and authentication

- `src/models/User.model.js`: added hashed refresh-session fields and token version. Non-breaking database defaults; existing tokens without a version remain version 0 until logout/rotation.
- `src/utils/token.js`: unique refresh JWT IDs, version claims, explicit secret failures, hash helper.
- `src/middlewares/auth.middleware.js`: removed header/JWT logs and verifies current database account state/version.
- `src/admin/middlewares/is-admin.middleware.js`: permits Admin/SuperAdmin consistently and uses shared authentication.
- `src/user/controllers/auth.controller.js`: atomic refresh rotation/reuse response, login hash persistence, real logout revocation, secret-log removal. Query-string refresh tokens are no longer accepted; use POST body or `x-refresh-token`.
- `src/utils/email.js`, `src/utils/send-verfication-email.js`: removed verification-token/link/HTML logging.

### Validation and error handling

- `src/middlewares/image.middleware.js`: one image, 5 MB limit, MIME allowlist.
- `src/storage/image-storage.service.js`: verifies decoded format before processing.
- `src/middlewares/error.middleware.js`: added JSON 404/error/Multer mapping.
- `src/index.js`, `tests/test-app.js`: 1 MB JSON body limit, disabled Express fingerprint, final handlers.
- `src/config/http.config.js`: deployment CORS allowlist with secure production fallback.
- Product, category, banner, order, and login-activity services: ObjectId/status/pagination/numeric/relation validation and sanitized failures.

### Data integrity and performance

- `src/models/cart.model.js`, `src/user/controllers/cart.controller.js`: optimistic concurrency, retry, duplicate-upsert recovery, bulk Product lookup.
- `src/services/order-pricing.service.js`: combines duplicate lines and fetches Products once.
- `src/services/order.service.js`: conditional stock reservation/rollback, payment-time online stock deduction, owned HMAC verification lock, atomic cancellation/restock.
- Product/category/banner image replacement now deletes old assets only after successful persistence; failed new assets are cleaned up.
- Category deletion now refuses linked Product data with 409.

### Tests and documentation

- `tests/api.test.js`: added concurrent cart, checkout oversell, and cancellation tests.
- Added the required documentation set, OpenAPI specification, Postman collection/environment, security/optimization/test reports.
- No dependency version or package-lock change was required.

### Compatibility

No route path, normal success body field, database field rename, image-provider choice, or Admin/User mounting prefix was removed. One intentional security behavior change: refresh tokens in URL query strings are rejected; clients must use POST JSON or the legacy GET header.

No migration script is required. Existing users receive default `tokenVersion:0`; their next login stores the refresh hash. A valid legacy refresh token can bootstrap once and is then rotated.
