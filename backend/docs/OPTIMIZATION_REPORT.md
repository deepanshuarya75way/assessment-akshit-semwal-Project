# Optimization report

## Baseline

The working tree already had user edits in `src/admin/controllers/admin.controller.js`, `src/models/product.model.js`, `src/user/controllers/cart.controller.js`, and `src/user/routes/cart.routes.js`; they were preserved and not attributed to this review. Baseline: 99 canonical operations, 81 legacy alias operations, 21 Mongoose models, one 66-test Jest suite. Pre-change test result: 51 passed, 11 failed, 4 skipped.

| File / function | Existing issue and evidence | Risk | Modification | Benefit / compatibility | Test result |
| --- | --- | --- | --- | --- | --- |
| `auth.middleware.js` | Printed all headers/JWT; trusted token role/state until expiry | High | Removed logs; reload current role, active/verified state, token version | Stops token leakage and blocked-user access; no route/body change | Secret-log and auth tests pass |
| `auth.controller.js`, `User.model.js`, `token.js` | Refresh JWT reusable; five concurrent refreshes succeeded; logout token remained valid | High | Hashed refresh state, unique JWT ID, atomic rotation, reuse detection, token-version logout | Existing token response fields retained; query-string refresh removed | Rotation/concurrency/logout tests pass |
| Admin middleware | `superAdmin` schema role received 403 | Medium | General Admin policy accepts Admin/SuperAdmin; order manager remains order-only | Matches model/route intent | Role tests pass |
| Upload/error middleware | Invalid type and 6 MB upload reached Sharp and returned 500 | Medium | MIME allowlist, 5 MB limit, decoded format validation, JSON error mapping | Valid image fields unchanged | 400/413 tests pass |
| Product/category/banner services | Invalid IDs produced CastError; missing product used 400; category relation and numeric bounds incomplete | Medium | ObjectId/relation/price/stock validation; 404 semantics; linked category delete 409 | No success contract changes | Catalog tests pass |
| Image create/update paths | Orphaned new assets possible; old product/category/banner image deleted before DB save | Medium | Cleanup failed new asset; persist replacement before deleting old | No URL field changes | Valid/invalid upload tests pass; live providers skipped |
| Cart model/controller | Read/save concurrency could create duplicates/lost increments | Medium | Optimistic concurrency, retry, duplicate-upsert recovery; products fetched in bulk | Same endpoints/response fields | Concurrent add test passes |
| `order-pricing.service.js` | Product query inside loop; duplicate lines independently checked | Medium | Normalize/combine items and fetch products once | Same item inputs; output snapshots combine duplicates | Order suite passes |
| `order.service.js` | Non-atomic stock decrements, oversell, duplicate cancel restock, online stock deducted before payment; payment lacked ownership/order binding/timing-safe compare | High | Conditional reserve/rollback, atomic cancel claim, defer online stock, owned one-time verify lock and timing-safe HMAC | Paths/bodies retained; unsafe state transitions corrected | Concurrent checkout/cancel tests pass |
| Login activity | Invalid pagination silently defaulted | Low | Strict integer validation, limit 1-100 | Invalid callers now receive 400 | Test passes |
| App shell | Default Express HTML errors and fingerprint; unrestricted JSON size | Low | JSON error/404 handler, 1 MB JSON limit, disable `x-powered-by` | Unknown routes now JSON 404 | Startup and suite pass |

## Reviewed but not changed

- Profile ownership: all CRUD filters use the authenticated token user.
- Return ownership and review purchase/ownership checks were already present.
- Razorpay PaymentIntent flow already verifies signature, fetches captured payment, checks amount/currency, uses idempotency, and attempts refund; no architectural rewrite was made.
- Coupon target/date/value checks and server-side discount calculation were retained.
- Policy slug normalization/audit behavior, homepage category validation, and audit-log helper were adequate.
- Storage provider abstraction, Sharp dimensions/quality, and local/Cloudinary/S3 selection were retained. Image dimensions were not changed.
- Existing indexes were not expanded without production query plans.
- Default pagination was not added to products/users/orders/audit/inventory/reviews because it would truncate current responses and risk frontend breakage. A versioned or opt-in migration is recommended.
- No Redis, queue, Nginx, Kubernetes, TypeScript rewrite, or route rename was introduced.

## Proposed changes not applied

1. Add versioned pagination to every unbounded collection endpoint after frontend coordination.
2. Add persistent/distributed rate limiting for login, registration, verification resend, reset, refresh, payment, and public analytics. An in-process custom limiter was intentionally not added because it is unreliable across multiple instances.
3. Make forgot-password responses account-agnostic after client/support approval.
4. Move legacy GET refresh and all legacy base-path aliases through a deprecation cycle.
5. Add production `explain()` evidence before new compound indexes.
6. Consolidate Product stock and Inventory stock into one authoritative model during a separately planned migration.
