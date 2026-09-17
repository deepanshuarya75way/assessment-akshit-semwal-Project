# API documentation

This document describes the 99 canonical operations mounted at `/api/v1`. The exact operation inventory is [API_ENDPOINT_SUMMARY.md](./API_ENDPOINT_SUMMARY.md); legacy aliases execute the same routers. JSON endpoints use `Content-Type: application/json`; protected endpoints additionally require:

```http
Authorization: Bearer <access_token>
```

Multipart endpoints omit a manually supplied content type so the client can add the boundary. Image fields are `User_image` for profile/category/product and `banner_image` for banners. One JPEG, PNG, WebP, GIF, or AVIF file up to 5 MB is accepted and decoded before WebP conversion.

Successful response shapes are historical and therefore vary (`data`, `order`, `orders`, `reviews`, `settings`, or `dashboard`). Errors generally contain `message` and may contain `success:false` or `code`. Relevant common statuses: `400` malformed/invalid input, `401` invalid authentication, `403` wrong role/account state/ownership, `404` absent resource, `409` conflict/race/state transition, `413` oversized upload, `500` unexpected failure, `503` unavailable provider.

## Authentication

| Endpoint | Request / validation | Success | Errors / side effects |
| --- | --- | --- | --- |
| `GET /user/auth/` | None | `200` health text | No side effects. |
| `POST /user/auth/create` | `{Email,Password,referralCode?}`; required email/password; referral must exist | `201 {message,user}` without password | `400` missing/duplicate/referral; `500`; creates User/Profile/verification record and sends email. Public role input is ignored. |
| `POST /user/auth/email-verify` | Header `x-verification-token` | `200 {message}` | `400` missing/invalid/used, `404` user; marks user verified and token used. |
| `POST /user/auth/login` | `{Email,Password}` | `200 {message,user,token:{accessToken,refreshToken},activityId}` | `400`, `401`, `403`, `500`; stores refresh hash and login activity. |
| `POST /user/auth/logout` | Bearer; `{activityId?}` | `200` | `401/403/500`; increments token version, removes refresh session, closes activity. |
| `POST /user/auth/forgot-password` | `{email}` | `200` | `400`, current `404` unknown account, `500`; stores expiring token hash and sends email. |
| `POST /user/auth/reset-password` | `{resetToken,password}` | `200` | `400`, `404` invalid/expired/used, `500`; atomically changes password and consumes token. |
| `POST /user/auth/refresh-token` | `{refreshToken}` | `200` with both top-level and nested rotated tokens | `400` missing, `401` invalid/expired/reused. Old hash becomes unusable. |
| `GET /user/auth/refresh-token` | Header `x-refresh-token`; legacy method | Same as POST | Query tokens are intentionally rejected to avoid URL/log leakage. |

## Profile and referral self-service

`POST /user/profile/create`, `PUT /user/profile/update-profile`, and `PATCH /user/profile/update-profile` accept optional multipart image and fields `fullName`, name parts, `phoneNumber|phone`, `dob`, `bio`, `gender`, address fields, and country. They always derive ownership from the bearer token; request-body user IDs, roles, verification, active state, wallet and referral counters are ignored. Success is `201` for create and `200` for updates. Empty updates return `400`; auth returns `401/403`; upload errors return `400/413`; unexpected persistence/provider failures return `500`.

`GET /user/profile/get-profile` returns `200 {data}` for the authenticated user (including `data:null` before creation). `GET /user/profile/referral-stats` returns only the caller's referral code/counters/wallet, or `404` if no profile exists. Avatar replacement uploads the new asset and updates the profile; provider-specific cleanup limitations are in the security report.

## Catalog, banners, and policies

| Endpoint | Parameters / body | Success | Validation and errors |
| --- | --- | --- | --- |
| `GET /user/products/all-product` | None | `200 {message,data:[...]}` with rating summaries | `500`; currently unpaginated for compatibility. |
| `GET /user/products/product-id/:id` | ObjectId `id` | `200 {data}` | `400` malformed, `404` absent, `500`. |
| `GET /user/products/category/:categoryId` | ObjectId | `200 {count,products}` | `400`, `500`. |
| `GET /user/categories/get-all` | None | `200 {data}` | `500`. |
| `GET /user/banners/all-banners` | `includeInactive?` exists but public default filters active | `200 {data}` | `500`. Public clients should not request inactive content. |
| `GET /user/banners/:id` | ObjectId | `200 {data}` | `400`, `404`, `500`. |
| `GET /user/policies/all-policies` | None | `200 {data}` sorted by position | `500`. |
| `GET /user/policies/:slug` | Normalized slug | `200 {data}` | `404`, `500`. |

Admin catalog mutations require Admin/SuperAdmin. Product create requires multipart `name`, `description`, non-negative `price`, valid existing `category_id`, `brand`, integer non-negative `stock`, `producthightlight`, and `User_image`; optional `mrp` must be non-negative. Update uses `PUT /admin/products/update/:id` and validates changed fields. Delete uses `/delete/:id`. Success is `200`; malformed IDs/fields are `400`, missing relations/resources `404`, upload too large `413`. Image create failures clean up the new asset; updates delete the prior image only after persistence succeeds.

Category create requires name/tagline/theme color/image; update accepts partial multipart fields. Deletion returns `409` while any Product references the category. Banner create/update accepts the styling fields visible in the Postman collection plus `banner_image`; delete removes the stored asset. Policy create/update requires title, slug, heading, and content; slugs are normalized/unique. Mutations create audit logs where implemented.

## Cart and wishlist

All cart data is selected by `req.user.id`. Admin purchasing roles are rejected. Product IDs and positive integer quantities are validated; prices are loaded from Product, not accepted from the client. Variant keys/values are normalized.

| Endpoint | Body | Success / side effect | Errors |
| --- | --- | --- | --- |
| `GET /user/cart/` | None; public health route | `200` | None. |
| `POST /user/cart/add` | `{productId|product,quantity|qty?,selectedVariants?}` | `200 {data:cart}`; merges existing variant | `400`, `403`, `404`, `409`, `500`. |
| `POST /user/cart/bulk` | `{items:[same fields...]}` | Adds all after bulk product fetch | Same. Duplicate request items combine. |
| `PATCH /user/cart/quantity` | selector `cartItemId` or product/variants; quantity | Sets exact quantity | `400/404/409/500`. |
| `PATCH /user/cart/increment-quantity` | selector | Adds one if stock permits | `400/404/409/500`. |
| `PATCH /user/cart/decrement-quantity` | selector | Removes one, never below one | `400/404/409/500`. |
| `GET /user/cart/me` | None | Own cart or empty object | `401/403/500`. Deleted populated products may be null but do not change ownership. |
| `DELETE /user/cart/delete` | selector | Deletes only own cart item | `404/500`. |
| `DELETE /user/cart/clear` | None | Clears own cart idempotently | `500`. |

Optimistic concurrency and duplicate-upsert recovery prevent simultaneous requests from creating duplicate same-product/variant items. Wishlist GET aliases return the caller's populated list; POST add aliases and DELETE remove aliases use `:productId`, validate existence/ownership, and never accept a user ID body field.

## Orders and payments

Order bodies contain `items:[{productId|product,quantity}]`, a shipping address (`fullName`, Indian mobile, address, city, state, six-digit PIN, country), optional coupon, and payment method. Prices/totals/discounts come from MongoDB. Duplicate product lines combine, and products are fetched in one query.

`POST /user/orders/place-order` and alias `/create` return `201 {order}`. COD stock decrements use conditional atomic updates with rollback, preventing oversell on standalone MongoDB. Legacy online methods create a Pending local order/Razorpay order but do not deduct stock until `POST /verify-payment`. Verification requires ownership, matching Razorpay order ID, timing-safe official HMAC verification, a one-time lock, and conditional stock reservation. `GET /my-orders` and `GET /:orderId` enforce ownership; Admin roles may view a single order. `PATCH /:orderId/cancel` atomically claims the transition and restocks once.

Preferred online flow: `POST /user/payment/razorpay/order` requires a 16-100 character `idempotencyKey`, items, address, optional coupon/wallet; it returns payment intent, key ID, Razorpay order ID, amount, currency. `POST /razorpay/verify` requires the three Razorpay response fields. It verifies ownership/signature/payment amount/currency and uses a MongoDB transaction for stock, order, wallet, and intent. It may return `409` and automatically attempt a refund if a captured payment cannot create the order. Transactions require Atlas/replica set; this was not live-tested.

Order list Admin operations are `/admin/orders/all` and `PATCH /admin/orders/:orderId/status`, accessible to Admin, SuperAdmin, or OrderManager. Status must be one of the Order model enum values.

## Coupons, reviews, returns, analytics, and administration

Coupon customer endpoints require auth: `GET /user/coupons/active?productIds=id1,id2` filters assignment/date/usage/target; `POST /apply` accepts `{couponId,items}` and calculates without redeeming. Admin `/admin/coupons` GET/POST and `/:id` PUT/DELETE validate target relation, dates, percentage/fixed value, limits, and minimum purchase.

Review public listing is `/user/reviews/product/:productId`. Eligibility, create/update, own list, update by `:reviewId`, and delete by `:reviewId` require auth and ownership; rating is 1-5, comment 3-1000 chars, and a delivered purchase is required. Admin list/moderation uses `/admin/reviews/all` and `/:reviewId/status`.

Return create requires an owned eligible order/product and valid quantity/reason; `/my` and `/:id` enforce ownership. Admin `/admin/returns` supports list filters/pagination and `PATCH /:id/status` for controlled states.

`POST /user/analytics/track-page` increments a page counter. Admin `/analytics/page-views` reads aggregates. Public analytics currently has no rate limiter, recorded as a remaining risk.

Admin dashboard/users endpoints return aggregates, filter users, and block/unblock only non-admin accounts. Login activities validate `page` and `limit` (1-100) and support status/search/date filters. Audit logs, inventory, homepage settings, and referral operations are enumerated in the endpoint summary and Postman collection. Large Admin user/order/audit/inventory/review lists remain unpaginated where adding a default limit would silently break existing clients; migration is proposed rather than applied.

## Representative responses

```json
{ "success": true, "message": "Operation completed successfully", "data": {} }
```

```json
{ "success": false, "message": "Invalid product id" }
```

```json
{
  "success": true,
  "data": [],
  "pagination": { "page": 1, "limit": 10, "total": 0, "totalPages": 1 }
}
```

For ready-to-send bodies and variables, import [the Postman collection](./postman/ecommerce-backend.postman_collection.json).
