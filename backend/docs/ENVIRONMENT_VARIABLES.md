# Environment variables

Placeholders only are shown. Required means required for the core server or when the related feature/provider is enabled.

| Variable | Required | Example | Description |
| --- | ---: | --- | --- |
| `port` | Yes | `3000` | HTTP listener port. |
| `CORS_ORIGINS` | Production | `https://shop.example.com,https://admin.example.com` | Comma-separated browser origins. Development defaults to `*`; production emits no CORS header when unset. |
| `mango_url` | Yes | `mongodb://127.0.0.1:27017/ecommerce` | MongoDB URI; legacy spelling retained. |
| `acess_token` | Yes | `replace-with-32-plus-random-characters` | Access-token signing secret; legacy spelling retained. |
| `refresh_token` | Yes | `replace-with-a-different-random-secret` | Refresh-token signing secret. |
| `SECRET_KEY` | Yes | `replace-with-password-pepper` | HMAC pepper used before bcrypt. |
| `FRONTEND_URL` | Email | `http://localhost:3000` | Email-verification frontend base. |
| `RESET_PASSWORD_FRONTEND_URL` | Email | `http://localhost:3000/reset-password` | Password-reset frontend base. |
| `PASSWORD_RESET_TOKEN_TTL_MINUTES` | No | `15` | Reset-token lifetime; capped at 1,440 minutes. |
| `EMAIL` | Email | `mailer@example.com` | SMTP account/from address. |
| `EMAIL_PASSWORD` | Email | `application-password` | SMTP credential. |
| `EMAIL_FROM_NAME` | No | `Astro Ecommerce` | Friendly From name. |
| `SMTP_HOST` | No | `smtp.gmail.com` | Defaults to Gmail SMTP. |
| `SMTP_PORT` | No | `465` | SMTP port. |
| `SMTP_SECURE` | No | `true` | Whether SMTP uses implicit TLS. |
| `IMAGE_STORAGE_PROVIDER` | Yes | `local` | `local`, `cloudinary`, or `s3`. |
| `USE_CLOUDINARY` | No | `false` | Legacy fallback flag when provider is unset. |
| `CLOUDINARY_CLOUD_NAME` | Cloudinary | `your-cloud` | Cloudinary cloud. |
| `CLOUDINARY_API_KEY` | Cloudinary | `your-api-key` | Cloudinary key. |
| `CLOUDINARY_API_SECRET` | Cloudinary | `your-api-secret` | Cloudinary secret. |
| `AWS_REGION` | S3 | `ap-south-1` | S3 region. |
| `AWS_ACCESS_KEY_ID` | S3 | `your-access-key` | AWS access key. |
| `AWS_SECRET_ACCESS_KEY` | S3 | `your-secret-key` | AWS secret. |
| `AWS_BUCKET_NAME` | S3 | `your-bucket` | S3 bucket. |
| `AWS_CLOUDFRONT_URL` | No | `https://cdn.example.com` | Recommended private-bucket delivery URL. |
| `RAZORPAY_KEY_ID` | Payments | `rzp_test_replace_me` | Razorpay sandbox key ID. |
| `RAZORPAY_KEY_SECRET` | Payments | `replace-me` | Razorpay sandbox secret. |
| `supabaseurl` | No | `https://project.supabase.co` | Present for an optional/unused Supabase integration. |
| `project_url` | No | `https://project.supabase.co` | Optional Supabase project URL. |
| `DATABASE_URL` | No | `postgresql://user:password@host/database` | Optional Supabase/PostgreSQL connection string; not used by the active MongoDB app. |
| `DIRECT_URL` | No | `postgresql://user:password@host/database` | Optional direct PostgreSQL URL; not used by the active app. |

The live `.env` was inventoried by variable name only. No secret value was copied into documentation.
