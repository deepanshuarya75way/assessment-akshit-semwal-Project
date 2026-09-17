# Security review

## Findings

### Critical

None confirmed after the applied fixes.

### High

- **Fixed: bearer and verification-token leakage in logs.** Header, user-document, verification-link, HTML, and upload-buffer debug logging was removed from affected paths.
- **Fixed: replayable refresh tokens and ineffective logout.** Refresh state is hashed, expires, rotates atomically, detects reuse, and is invalidated by logout token version.
- **Fixed: checkout oversell and fake legacy payment binding.** COD stock is conditionally decremented with rollback. Legacy payment verification now requires order ownership, matching Razorpay order ID, official HMAC, timing-safe comparison, one-time lock, and stock reservation after payment.

### Medium

- **Fixed: blocked/unverified users could retain protected access.** Middleware reloads current account state.
- **Fixed: unsafe upload size/type handling.** 5 MB limit, MIME allowlist, decoded image format check, and JSON 400/413 responses are present.
- **Fixed: category deletion could break linked products.** Returns 409 while referenced.
- **Fixed: duplicate cancellation could over-restock.** Cancellation state is claimed atomically.
- **Fixed/configurable: CORS.** `CORS_ORIGINS` provides a comma-separated allowlist. Development retains wildcard compatibility when unset; production emits no CORS permission when unset.
- **Remaining: no persistent rate limiting.** Sensitive/public abuse endpoints are not throttled. Use a maintained distributed limiter/store appropriate to the deployment.
- **Remaining: forgot-password enumeration.** Unknown accounts return 404. Changing this requires contract/support coordination.
- **Remaining: unbounded collections.** Admin users/orders/audit/inventory/reviews and public products may expose resource-exhaustion risk. Pagination migration is high priority.
- **Remaining: duplicate stock representations.** Product and Inventory can drift outside controlled update paths.

### Low

- Helmet is not installed. `x-powered-by` is disabled and final errors are sanitized, but an API-appropriate security-header policy remains recommended.
- Access/refresh secret strength is deployment-controlled; startup does not enforce minimum entropy.
- Some controllers still log generic error objects/messages. No intentional token/password/payment-secret logging remains in reviewed paths, but structured redaction should replace ad-hoc console logging.
- Login activity stores IP/device/location data; establish retention and privacy policy.

### Informational / positive controls

- Public registration cannot assign a privileged role.
- Passwords use a configured HMAC pepper plus bcrypt.
- Reset tokens are random, hashed, expiring, and one-time.
- Sensitive User fields are selected out and Admin user serialization omits password/reset state.
- Profile/cart/order/return/review ownership uses authenticated user identity.
- Server recalculates catalog prices and checkout totals.
- Razorpay PaymentIntent flow uses idempotency, signature verification, provider payment fetch, amount/currency check, MongoDB transaction, and automatic refund attempt.
- Production dependency audit reported zero known vulnerabilities in 204 production dependencies on 2026-07-16.

## Review areas

- Authentication/authorization: reviewed registration, verification, login, access, refresh, logout, reset, blocking, Admin and OrderManager policy.
- Validation/NoSQL injection: explicit ObjectId and scalar validation exists in core high-risk paths; bodies use allowlisted assignments rather than spreading arbitrary request objects in reviewed mutations.
- Ownership/IDOR: cart/profile/order/return/review/wishlist use token identity or ownership filters.
- Uploads: in-memory one-file limit, MIME plus decode validation, provider config, cleanup, replacement ordering.
- CORS is configurable; persistent rate limiting remains a Medium item above.
- Secret management: `.env` ignored; docs contain placeholders only. Live values were never printed.
- Dependency review: `npm audit --omit=dev --json` returned 0 vulnerabilities.

## Production readiness

The backend is substantially safer but not fully production-ready until CORS origins, persistent rate limits, paginated large lists, payment transaction deployment requirements, external provider sandbox tests, secret-strength policy, and operational logging/monitoring are completed.
