# API test report

## Environment

- Windows / Node.js `v22.9.0`
- Jest 30, Supertest, MongoDB Memory Server using cached MongoDB `8.2.6`
- Isolated temporary database deleted after each test
- Nodemailer mocked; no real email sent
- Local image processing tested through Sharp
- Actual `.env` MongoDB startup separately verified on port 3099 and shut down

Baseline command initially hung while MongoDB Memory Server attempted startup. Selecting the already cached binary made the failure reproducible:

```powershell
$env:MONGOMS_SYSTEM_BINARY='C:\Users\User\.cache\mongodb-binaries\mongod-x64-win32-8.2.6.exe'
$env:MONGOMS_RUNTIME_DOWNLOAD='false'
npm test
```

## Result summary

| Stage | Passed | Failed | Skipped | Total |
| --- | ---: | ---: | ---: | ---: |
| Pre-change baseline | 51 | 11 | 4 | 66 |
| After baseline fixes | 62 | 0 | 4 | 66 |
| Final expanded regression | 65 | 0 | 4 | 69 |

## Scenario results

| Module | Endpoint / scenario | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| Startup | Root health with configured MongoDB | Mongo connects, HTTP 200 | Connected; 200 | Pass |
| Auth | Registration, verification, login, missing/invalid/expired access | Correct 2xx/4xx, no password | As expected | Pass |
| Auth | Bearer token not logged | No JWT in logs | No JWT | Pass |
| Refresh | Valid/invalid/expired, reuse, five concurrent calls | Rotate once; old rejected | As expected | Pass |
| Logout | Reuse access token after logout | 401 | 401 | Pass |
| Reset | Hash/expiry/one-time/expired reset | Safe one-time behavior | As expected | Pass |
| Admin | Missing/user/Admin/SuperAdmin/blocked | Role/state policy | As expected | Pass |
| Upload | Valid category image | 201 | 201 | Pass |
| Upload | Text file and 6 MB file | 400 and 413 | 400 and 413 | Pass |
| Product | Public list/detail; malformed/missing ID | 200/400/404 | As expected | Pass |
| Cart | Auth, invalid payload/ID, add/get | Correct ownership/validation | As expected | Pass |
| Cart | Two simultaneous same-item additions | One line, quantity 2 | One line, quantity 2 | Pass |
| Banner | Public list/detail; Admin create | Correct 2xx/4xx | As expected | Pass |
| Orders | Empty/invalid, COD stock deduction | Correct 4xx/201 and stock | As expected | Pass |
| Orders | Two buyers/requests compete for stock 1 | One 201, one 409, stock 0 | As expected | Pass |
| Orders | Two simultaneous cancellations | One succeeds; stock restored once | As expected | Pass |
| Orders | Malformed order ID; Admin list | 400 / 200 | As expected | Pass |
| Pagination | Invalid login activity page/limit | 400 | 400 | Pass |
| Dependencies | `npm audit --omit=dev` | Report findings | 0 vulnerabilities | Pass |
| Razorpay | Real create/capture/refund | Sandbox integration | Not run | Skipped |
| S3 | Real upload/delete | Test bucket | Not run | Skipped |
| Cloudinary | Real upload/delete | Test folder | Not run | Skipped |
| SMTP | Real verification/reset email | Sandbox inbox | Not run | Skipped |

No newly introduced test failures remain. `tests/jest-results.json` represents the last JSON-formatted 66-test run; the later expanded console run completed 65/65 executable tests.

Coverage generation command:

```powershell
npm test -- --coverage
```

It was not run during this review; no coverage percentage is claimed.
