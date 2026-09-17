import fs from "node:fs";

const P = "public";
const U = "user";
const A = "admin";
const O = "orders";

const endpoints = [
  ["get", "/user/auth/", P, "Authentication", "Authentication health"],
  ["post", "/user/auth/create", P, "Authentication", "Register customer", "Registration"],
  ["post", "/user/auth/email-verify", P, "Authentication", "Verify email"],
  ["post", "/user/auth/login", P, "Authentication", "Login", "Login"],
  ["post", "/user/auth/logout", U, "Authentication", "Logout"],
  ["post", "/user/auth/forgot-password", P, "Authentication", "Request password reset", "Email"],
  ["post", "/user/auth/reset-password", P, "Authentication", "Reset password", "ResetPassword"],
  ["get", "/user/auth/refresh-token", P, "Authentication", "Refresh token using header"],
  ["post", "/user/auth/refresh-token", P, "Authentication", "Refresh token", "RefreshToken"],
  ...[
    ["post", "/user/profile/create", "Create profile"], ["get", "/user/profile/get-profile", "Get profile"],
    ["put", "/user/profile/update-profile", "Replace profile"], ["patch", "/user/profile/update-profile", "Patch profile"],
    ["get", "/user/profile/referral-stats", "Get referral stats"],
  ].map(([m,p,s]) => [m,p,U,"Profiles",s]),
  ...[
    ["get", "/user/products/all-product", "List products"], ["get", "/user/products/product-id/:id", "Get product"],
    ["get", "/user/products/category/:categoryId", "Products by category"],
  ].map(([m,p,s]) => [m,p,P,"Products",s]),
  ["get", "/user/categories/get-all", P, "Categories", "List categories"],
  ["get", "/user/cart/", P, "Cart", "Cart health"],
  ...[
    ["post", "/user/cart/bulk", "Bulk add cart", "CartBulk"], ["post", "/user/cart/add", "Add cart item", "CartItem"],
    ["patch", "/user/cart/quantity", "Set cart quantity", "CartItem"], ["patch", "/user/cart/increment-quantity", "Increment cart quantity", "CartItem"],
    ["patch", "/user/cart/decrement-quantity", "Decrement cart quantity", "CartItem"], ["get", "/user/cart/me", "Get cart"],
    ["delete", "/user/cart/delete", "Delete cart item", "CartItem"], ["delete", "/user/cart/clear", "Clear cart"],
  ].map(([m,p,s,b]) => [m,p,U,"Cart",s,b]),
  ...[
    ["get", "/user/wishlist/get-wishlist", "Get wishlist alias"], ["get", "/user/wishlist/me", "Get wishlist"],
    ["post", "/user/wishlist/add-wishlist/:productId", "Add wishlist alias"], ["post", "/user/wishlist/add/:productId", "Add wishlist"],
    ["delete", "/user/wishlist/remove-wishlist/:productId", "Remove wishlist alias"], ["delete", "/user/wishlist/remove/:productId", "Remove wishlist"],
  ].map(([m,p,s]) => [m,p,U,"Wishlist",s]),
  ...[
    ["post", "/user/orders/create", "Place order alias", "Order"], ["post", "/user/orders/place-order", "Place order", "Order"],
    ["post", "/user/orders/verify-payment", "Verify legacy payment", "PaymentVerify"], ["get", "/user/orders/my-orders", "List own orders"],
    ["get", "/user/orders/:orderId", "Get order"], ["patch", "/user/orders/:orderId/cancel", "Cancel order"],
  ].map(([m,p,s,b]) => [m,p,U,"Orders",s,b]),
  ["post", "/user/payment/razorpay/order", U, "Payments", "Create Razorpay payment intent", "PaymentIntent"],
  ["post", "/user/payment/razorpay/verify", U, "Payments", "Verify Razorpay payment", "PaymentVerify"],
  ["get", "/user/coupons/active", U, "Coupons", "List available coupons"],
  ["post", "/user/coupons/apply", U, "Coupons", "Apply coupon", "CouponApply"],
  ...[
    ["post", "/user/returns/", "Create return"], ["get", "/user/returns/my", "List own returns"], ["get", "/user/returns/:id", "Get return"],
  ].map(([m,p,s]) => [m,p,U,"Returns",s]),
  ...[
    ["get", "/user/reviews/product/:productId", P, "List product reviews"],
    ["get", "/user/reviews/product/:productId/eligibility", U, "Review eligibility"],
    ["post", "/user/reviews/product/:productId", U, "Create or update review", "Review"],
    ["get", "/user/reviews/my-reviews", U, "List own reviews"],
    ["put", "/user/reviews/:reviewId", U, "Update review", "Review"], ["delete", "/user/reviews/:reviewId", U, "Delete review"],
  ].map(([m,p,auth,s,b]) => [m,p,auth,"Reviews",s,b]),
  ["get", "/user/banners/all-banners", P, "Banners", "List active banners"], ["get", "/user/banners/:id", P, "Banners", "Get banner"],
  ["get", "/user/policies/all-policies", P, "Policies", "List policies"], ["get", "/user/policies/:slug", P, "Policies", "Get policy"],
  ["post", "/user/analytics/track-page", P, "Analytics", "Track page view"],
  ...[
    ["get", "/admin/dashboard", "Dashboard"], ["get", "/admin/all-users", "List users"], ["put", "/admin/block/:id", "Block user"],
    ["put", "/admin/unblock/:id", "Unblock user"], ["get", "/admin/login-activities", "List login activities"],
  ].map(([m,p,s]) => [m,p,A,"Admin",s]),
  ["get", "/admin/audit-logs/", A, "Audit", "List audit logs"],
  ...[
    ["post", "/admin/products/create", "Create product"], ["put", "/admin/products/update/:id", "Update product"], ["delete", "/admin/products/delete/:id", "Delete product"],
  ].map(([m,p,s]) => [m,p,A,"Products",s]),
  ...[
    ["post", "/admin/categories/create", "Create category"], ["put", "/admin/categories/update/:categoryId", "Update category"], ["delete", "/admin/categories/delete/:categoryId", "Delete category"],
  ].map(([m,p,s]) => [m,p,A,"Categories",s]),
  ...[
    ["post", "/admin/banners/create", "Create banner"], ["put", "/admin/banners/update/:id", "Update banner"], ["delete", "/admin/banners/delete/:id", "Delete banner"],
  ].map(([m,p,s]) => [m,p,A,"Banners",s]),
  ["get", "/admin/coupons/", A, "Coupons", "List coupons"], ["post", "/admin/coupons/", A, "Coupons", "Create coupon"],
  ["put", "/admin/coupons/:id", A, "Coupons", "Update coupon"], ["delete", "/admin/coupons/:id", A, "Coupons", "Delete coupon"],
  ...[
    ["post", "/admin/inventory/create", "Create inventory"], ["post", "/admin/inventory/insert-missing", "Backfill inventory"],
    ["get", "/admin/inventory/get-inventory", "List inventory"], ["get", "/admin/inventory/:productId", "Get inventory"], ["put", "/admin/inventory/:productId", "Update stock"],
  ].map(([m,p,s]) => [m,p,A,"Inventory",s]),
  ["get", "/admin/orders/all", O, "Orders", "List all orders"], ["patch", "/admin/orders/:orderId/status", O, "Orders", "Update order status"],
  ["get", "/admin/returns/", A, "Returns", "List returns"], ["patch", "/admin/returns/:id/status", A, "Returns", "Update return status"],
  ["get", "/admin/reviews/all", A, "Reviews", "List reviews"], ["patch", "/admin/reviews/:reviewId/status", A, "Reviews", "Moderate review"],
  ["post", "/admin/policies/create", A, "Policies", "Create policy"], ["put", "/admin/policies/update/:id", A, "Policies", "Update policy"], ["delete", "/admin/policies/delete/:id", A, "Policies", "Delete policy"],
  ["get", "/admin/analytics/page-views", A, "Analytics", "Get page views"],
  ["get", "/admin/homepage/settings", A, "Homepage", "Get homepage settings"], ["put", "/admin/homepage/Update-settings", A, "Homepage", "Update homepage settings"],
  ["get", "/admin/referrals/settings", A, "Referrals", "Get referral settings"], ["put", "/admin/referrals/settings", A, "Referrals", "Update referral settings"],
  ["get", "/admin/referrals/stats", A, "Referrals", "Get referral stats"], ["get", "/admin/referrals/details", A, "Referrals", "Get referral details"],
  ["delete", "/admin/referrals/referrer/:id", A, "Referrals", "Clear referrer totals"], ["delete", "/admin/referrals/discount/:id", A, "Referrals", "Delete referral coupon"],
];

const schemaRef = (name) => ({ $ref: `#/components/schemas/${name}` });
const parametersFor = (path) => [...path.matchAll(/:([A-Za-z0-9_]+)/g)].map(([, name]) => ({
  name, in: "path", required: true, schema: { type: "string" }, description: `${name} identifier or slug`,
}));
const queryParametersFor = (path) => {
  const result = [];
  if (/all-users|login-activities|audit-logs|returns|reviews\/all|inventory\/get-inventory/.test(path)) {
    result.push({ name: "search", in: "query", required: false, schema: { type: "string" } });
  }
  if (/login-activities|admin\/returns/.test(path)) {
    result.push(
      { name: "page", in: "query", required: false, schema: { type: "integer", minimum: 1, default: 1 } },
      { name: "limit", in: "query", required: false, schema: { type: "integer", minimum: 1, maximum: 100, default: 10 } },
    );
  }
  if (path.endsWith("/coupons/active")) result.push({ name: "productIds", in: "query", required: false, schema: { type: "string" } });
  return result;
};

const paths = {};
const multipartPaths = new Set([
  "/user/profile/create",
  "/user/profile/update-profile",
  "/admin/products/create",
  "/admin/products/update/:id",
  "/admin/categories/create",
  "/admin/categories/update/:categoryId",
  "/admin/banners/create",
  "/admin/banners/update/:id",
]);
const bodylessMutationPaths = new Set([
  "/user/auth/email-verify",
  "/admin/inventory/insert-missing",
]);
for (const [method, expressPath, auth, tag, summary, bodySchema] of endpoints) {
  const path = expressPath.replace(/:([A-Za-z0-9_]+)/g, "{$1}");
  paths[path] ||= {};
  const parameters = [...parametersFor(expressPath), ...queryParametersFor(expressPath)];
  if (expressPath === "/user/auth/email-verify") parameters.push({ name: "x-verification-token", in: "header", required: true, schema: { type: "string" } });
  if (method === "get" && expressPath === "/user/auth/refresh-token") parameters.push({ name: "x-refresh-token", in: "header", required: true, schema: { type: "string" } });
  const hasBody =
    bodySchema ||
    (["post", "put", "patch"].includes(method) &&
      !bodylessMutationPaths.has(expressPath));
  const contentType = multipartPaths.has(expressPath)
    ? "multipart/form-data"
    : "application/json";
  paths[path][method] = {
    tags: [tag], summary,
    operationId: `${method}_${expressPath.replace(/[^A-Za-z0-9]+/g, "_").replace(/^_|_$/g, "")}`,
    ...(auth === P ? {} : { security: [{ bearerAuth: [] }] }),
    ...(parameters.length ? { parameters } : {}),
    ...(hasBody ? { requestBody: { required: !["get", "delete"].includes(method), content: { [contentType]: { schema: schemaRef(bodySchema || "GenericBody") } } } } : {}),
    responses: {
      "200": { description: "Successful request", content: { "application/json": { schema: schemaRef("SuccessResponse") } } },
      "201": { description: "Resource created", content: { "application/json": { schema: schemaRef("SuccessResponse") } } },
      "400": { $ref: "#/components/responses/BadRequest" }, "401": { $ref: "#/components/responses/Unauthorized" },
      "403": { $ref: "#/components/responses/Forbidden" }, "404": { $ref: "#/components/responses/NotFound" },
      "409": { $ref: "#/components/responses/Conflict" }, "413": { $ref: "#/components/responses/PayloadTooLarge" },
      "500": { $ref: "#/components/responses/ServerError" },
    },
  };
}

const errorResponse = (description) => ({ description, content: { "application/json": { schema: schemaRef("ErrorResponse") } } });
const spec = {
  openapi: "3.1.0",
  info: { title: "GameENGINE E-commerce Backend API", version: "1.0.0", description: "Canonical Admin and User operations. Legacy aliases are documented separately and invoke the same routers." },
  servers: [{ url: "http://localhost:{port}/api/v1", variables: { port: { default: "3000" } } }, { url: "https://api.example.com/api/v1" }],
  tags: [...new Set(endpoints.map((endpoint) => endpoint[3]))].map((name) => ({ name })),
  paths,
  components: {
    securitySchemes: { bearerAuth: { type: "http", scheme: "bearer", bearerFormat: "JWT" } },
    responses: {
      BadRequest: errorResponse("Invalid request"), Unauthorized: errorResponse("Missing, invalid, expired, rotated, or logged-out authentication"),
      Forbidden: errorResponse("Authenticated account lacks role, state, or ownership"), NotFound: errorResponse("Resource not found"),
      Conflict: errorResponse("Uniqueness, concurrency, stock, or state-transition conflict"), PayloadTooLarge: errorResponse("Image exceeds 5 MB"),
      ServerError: errorResponse("Unexpected server error"),
    },
    schemas: {
      ErrorResponse: { type: "object", properties: { success: { type: "boolean", const: false }, message: { type: "string" }, errors: { type: "array", items: {} }, code: { type: "string" } }, required: ["message"] },
      SuccessResponse: { type: "object", additionalProperties: true, properties: { success: { type: "boolean" }, message: { type: "string" }, data: {}, pagination: schemaRef("Pagination") } },
      Pagination: { type: "object", properties: { page: { type: "integer" }, limit: { type: "integer" }, total: { type: "integer" }, totalItems: { type: "integer" }, totalPages: { type: "integer" } } },
      GenericBody: { type: "object", additionalProperties: true },
      Registration: { type: "object", required: ["Email", "Password"], properties: { Email: { type: "string", format: "email" }, Password: { type: "string", format: "password" }, referralCode: { type: "string" } } },
      Login: { type: "object", required: ["Email", "Password"], properties: { Email: { type: "string", format: "email" }, Password: { type: "string", format: "password" } } },
      Email: { type: "object", required: ["email"], properties: { email: { type: "string", format: "email" } } },
      ResetPassword: { type: "object", required: ["resetToken", "password"], properties: { resetToken: { type: "string" }, password: { type: "string", format: "password" } } },
      RefreshToken: { type: "object", required: ["refreshToken"], properties: { refreshToken: { type: "string" } } },
      CartItem: { type: "object", properties: { cartItemId: { type: "string" }, productId: { type: "string" }, quantity: { type: "integer", minimum: 1 }, selectedVariants: { type: "object", additionalProperties: { type: "string" } } } },
      CartBulk: { type: "object", required: ["items"], properties: { items: { type: "array", minItems: 1, items: schemaRef("CartItem") } } },
      ShippingAddress: { type: "object", required: ["fullName", "phone", "address", "city", "state", "pincode"], properties: { fullName: { type: "string" }, phone: { type: "string", pattern: "^[6-9][0-9]{9}$" }, address: { type: "string" }, city: { type: "string" }, state: { type: "string" }, pincode: { type: "string", pattern: "^[1-9][0-9]{5}$" }, country: { type: "string", default: "India" } } },
      Order: { type: "object", required: ["items", "shippingAddress"], properties: { items: { type: "array", minItems: 1, items: schemaRef("CartItem") }, shippingAddress: schemaRef("ShippingAddress"), paymentMethod: { type: "string", enum: ["COD", "cod", "UPI", "upi", "CARD", "card"] }, coupon: { type: ["string", "null"] } } },
      PaymentIntent: { allOf: [schemaRef("Order"), { type: "object", required: ["idempotencyKey"], properties: { idempotencyKey: { type: "string", minLength: 16, maxLength: 100 }, useWallet: { type: "boolean" } } }] },
      PaymentVerify: { type: "object", required: ["razorpay_order_id", "razorpay_payment_id", "razorpay_signature"], properties: { orderId: { type: "string" }, razorpay_order_id: { type: "string" }, razorpay_payment_id: { type: "string" }, razorpay_signature: { type: "string" } } },
      CouponApply: { type: "object", required: ["couponId", "items"], properties: { couponId: { type: "string" }, items: { type: "array", items: schemaRef("CartItem") } } },
      Review: { type: "object", required: ["rating", "comment"], properties: { rating: { type: "integer", minimum: 1, maximum: 5 }, comment: { type: "string", minLength: 3, maxLength: 1000 } } },
    },
  },
};

fs.writeFileSync(new URL("./openapi.yaml", import.meta.url), `${JSON.stringify(spec, null, 2)}\n`);
console.log(`Generated docs/openapi.yaml with ${endpoints.length} operations`);
