# API endpoint summary

Base URL: `http://localhost:3000/api/v1`. The inventory contains 99 canonical method/path operations and 81 compatibility-alias operations that mount the same routers under legacy prefixes.

| Module | Method | Endpoint | Authentication | Role | Description |
| --- | --- | --- | --- | --- | --- |
| Health | GET | `/user/auth/` | No | Public | Auth-router health response. |
| Authentication | POST | `/user/auth/create` | No | Public | Register customer. |
| Authentication | POST | `/user/auth/email-verify` | No | Public | Verify token from header. |
| Authentication | POST | `/user/auth/login` | No | Public | Login and issue tokens. |
| Authentication | POST | `/user/auth/logout` | Yes | Any active user | Revoke tokens/logout activity. |
| Authentication | POST | `/user/auth/forgot-password` | No | Public | Send reset email. |
| Authentication | POST | `/user/auth/reset-password` | No | Public | Consume reset token. |
| Authentication | GET, POST | `/user/auth/refresh-token` | Refresh token | Public | Atomically rotate tokens. |
| Profiles | POST | `/user/profile/create` | Yes | Customer | Create/upsert profile. |
| Profiles | GET | `/user/profile/get-profile` | Yes | Customer | Get own profile. |
| Profiles | PUT, PATCH | `/user/profile/update-profile` | Yes | Customer | Update own profile. |
| Profiles | GET | `/user/profile/referral-stats` | Yes | Customer | Own referral/wallet stats. |
| Products | GET | `/user/products/all-product` | No | Public | List products. |
| Products | GET | `/user/products/product-id/:id` | No | Public | Product detail. |
| Products | GET | `/user/products/category/:categoryId` | No | Public | Products by category. |
| Categories | GET | `/user/categories/get-all` | No | Public | List categories. |
| Cart | GET | `/user/cart/` | No | Public | Cart-router health response. |
| Cart | POST | `/user/cart/bulk` | Yes | Customer | Add multiple items. |
| Cart | POST | `/user/cart/add` | Yes | Customer | Add one item. |
| Cart | PATCH | `/user/cart/quantity` | Yes | Customer | Set quantity. |
| Cart | PATCH | `/user/cart/increment-quantity` | Yes | Customer | Increment quantity. |
| Cart | PATCH | `/user/cart/decrement-quantity` | Yes | Customer | Decrement quantity. |
| Cart | GET | `/user/cart/me` | Yes | Customer | Get own cart. |
| Cart | DELETE | `/user/cart/delete` | Yes | Customer | Delete own cart item. |
| Cart | DELETE | `/user/cart/clear` | Yes | Customer | Clear own cart. |
| Wishlist | GET | `/user/wishlist/get-wishlist` | Yes | Customer | Get wishlist alias. |
| Wishlist | GET | `/user/wishlist/me` | Yes | Customer | Get own wishlist. |
| Wishlist | POST | `/user/wishlist/add-wishlist/:productId` | Yes | Customer | Add product alias. |
| Wishlist | POST | `/user/wishlist/add/:productId` | Yes | Customer | Add product. |
| Wishlist | DELETE | `/user/wishlist/remove-wishlist/:productId` | Yes | Customer | Remove product alias. |
| Wishlist | DELETE | `/user/wishlist/remove/:productId` | Yes | Customer | Remove product. |
| Orders | POST | `/user/orders/create` | Yes | Customer | Place order alias. |
| Orders | POST | `/user/orders/place-order` | Yes | Customer | Server-priced COD/legacy online order. |
| Orders | POST | `/user/orders/verify-payment` | Yes | Customer | Verify owned legacy Razorpay order. |
| Orders | GET | `/user/orders/my-orders` | Yes | Customer | List own orders. |
| Orders | GET | `/user/orders/:orderId` | Yes | Owner/Admin role | Get owned/managed order. |
| Orders | PATCH | `/user/orders/:orderId/cancel` | Yes | Owner | Cancel eligible own order. |
| Payments | POST | `/user/payment/razorpay/order` | Yes | Customer | Create idempotent payment intent. |
| Payments | POST | `/user/payment/razorpay/verify` | Yes | Customer | Verify/capture and create order. |
| Coupons | GET | `/user/coupons/active` | Yes | Customer | Applicable coupons. |
| Coupons | POST | `/user/coupons/apply` | Yes | Customer | Calculate discount. |
| Returns | POST | `/user/returns/` | Yes | Customer | Create owned order return. |
| Returns | GET | `/user/returns/my` | Yes | Customer | List own returns. |
| Returns | GET | `/user/returns/:id` | Yes | Owner | Return detail. |
| Reviews | GET | `/user/reviews/product/:productId` | No | Public | Published product reviews. |
| Reviews | GET | `/user/reviews/product/:productId/eligibility` | Yes | Customer | Purchase eligibility. |
| Reviews | POST | `/user/reviews/product/:productId` | Yes | Customer | Create/update verified review. |
| Reviews | GET | `/user/reviews/my-reviews` | Yes | Customer | Own reviews. |
| Reviews | PUT | `/user/reviews/:reviewId` | Yes | Owner | Update own review. |
| Reviews | DELETE | `/user/reviews/:reviewId` | Yes | Owner | Delete own review. |
| Banners | GET | `/user/banners/all-banners` | No | Public | Active banners. |
| Banners | GET | `/user/banners/:id` | No | Public | Banner detail. |
| Policies | GET | `/user/policies/all-policies` | No | Public | List policies. |
| Policies | GET | `/user/policies/:slug` | No | Public | Policy by slug. |
| Analytics | POST | `/user/analytics/track-page` | No | Public | Increment page view. |
| Admin | GET | `/admin/dashboard` | Yes | Admin/SuperAdmin | Dashboard aggregates. |
| Admin | GET | `/admin/all-users` | Yes | Admin/SuperAdmin | Filter users. |
| Admin | PUT | `/admin/block/:id` | Yes | Admin/SuperAdmin | Block customer. |
| Admin | PUT | `/admin/unblock/:id` | Yes | Admin/SuperAdmin | Unblock customer. |
| Admin | GET | `/admin/login-activities` | Yes | Admin/SuperAdmin | Paginated activities. |
| Audit | GET | `/admin/audit-logs/` | Yes | Admin/SuperAdmin | Audit log list. |
| Products | POST | `/admin/products/create` | Yes | Admin/SuperAdmin | Create product/image. |
| Products | PUT | `/admin/products/update/:id` | Yes | Admin/SuperAdmin | Update product/image. |
| Products | DELETE | `/admin/products/delete/:id` | Yes | Admin/SuperAdmin | Delete product/image. |
| Categories | POST | `/admin/categories/create` | Yes | Admin/SuperAdmin | Create category/image. |
| Categories | PUT | `/admin/categories/update/:categoryId` | Yes | Admin/SuperAdmin | Update category/image. |
| Categories | DELETE | `/admin/categories/delete/:categoryId` | Yes | Admin/SuperAdmin | Delete unreferenced category. |
| Banners | POST | `/admin/banners/create` | Yes | Admin/SuperAdmin | Create banner. |
| Banners | PUT | `/admin/banners/update/:id` | Yes | Admin/SuperAdmin | Update banner. |
| Banners | DELETE | `/admin/banners/delete/:id` | Yes | Admin/SuperAdmin | Delete banner. |
| Coupons | GET, POST | `/admin/coupons/` | Yes | Admin/SuperAdmin | List/create coupons. |
| Coupons | PUT, DELETE | `/admin/coupons/:id` | Yes | Admin/SuperAdmin | Update/delete coupon. |
| Inventory | POST | `/admin/inventory/create` | Yes | Admin/SuperAdmin | Create inventory. |
| Inventory | POST | `/admin/inventory/insert-missing` | Yes | Admin/SuperAdmin | Backfill inventory. |
| Inventory | GET | `/admin/inventory/get-inventory` | Yes | Admin/SuperAdmin | Inventory list. |
| Inventory | GET, PUT | `/admin/inventory/:productId` | Yes | Admin/SuperAdmin | Read/update stock. |
| Orders | GET | `/admin/orders/all` | Yes | Admin/SuperAdmin/OrderManager | List orders. |
| Orders | PATCH | `/admin/orders/:orderId/status` | Yes | Admin/SuperAdmin/OrderManager | Update order state. |
| Returns | GET | `/admin/returns/` | Yes | Admin/SuperAdmin | List returns. |
| Returns | PATCH | `/admin/returns/:id/status` | Yes | Admin/SuperAdmin | Decide return. |
| Reviews | GET | `/admin/reviews/all` | Yes | Admin/SuperAdmin | Filter reviews. |
| Reviews | PATCH | `/admin/reviews/:reviewId/status` | Yes | Admin/SuperAdmin | Moderate review. |
| Policies | POST | `/admin/policies/create` | Yes | Admin/SuperAdmin | Create policy. |
| Policies | PUT | `/admin/policies/update/:id` | Yes | Admin/SuperAdmin | Update policy. |
| Policies | DELETE | `/admin/policies/delete/:id` | Yes | Admin/SuperAdmin | Delete policy. |
| Analytics | GET | `/admin/analytics/page-views` | Yes | Admin/SuperAdmin | Page-view aggregates. |
| Homepage | GET | `/admin/homepage/settings` | Yes | Admin/SuperAdmin | Homepage settings. |
| Homepage | PUT | `/admin/homepage/Update-settings` | Yes | Admin/SuperAdmin | Update settings. |
| Referrals | GET, PUT | `/admin/referrals/settings` | Yes | Admin/SuperAdmin | Get/update reward settings. |
| Referrals | GET | `/admin/referrals/stats` | Yes | Admin/SuperAdmin | Referral aggregates. |
| Referrals | GET | `/admin/referrals/details` | Yes | Admin/SuperAdmin | Referral details. |
| Referrals | DELETE | `/admin/referrals/referrer/:id` | Yes | Admin/SuperAdmin | Clear referrer totals. |
| Referrals | DELETE | `/admin/referrals/discount/:id` | Yes | Admin/SuperAdmin | Delete referral coupon. |

Legacy paths mount the same handlers under `/auth`, `/banner`, `/cart`, `/category`, `/coupon`, `/order`, `/policy`, `/product`, `/review`, `/wishlist`, `/analytics`, `/payment`, `/return`, and selected Admin aliases. Canonical `/user/*` and `/admin/*` paths should be used by new clients.
