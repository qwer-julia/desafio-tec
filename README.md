# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Deploy (Render + Neon, free tier)

1. **Neon**: create a project at https://neon.tech, then copy the pooled connection string (looks like `postgres://user:pass@ep-xxx-pooler.region.aws.neon.tech/neondb?sslmode=require`).
2. **Render**: push this repo to GitHub, then in Render click New > Blueprint and point it at the repo — it will read `render.yaml` and create the web service.
3. When prompted for env vars, set:
   - `DATABASE_URL` — the Neon connection string from step 1.
   - `RAILS_MASTER_KEY` — the contents of `config/master.key` (never commit this file).
4. Deploy. The container runs `bin/db:prepare` on boot (via `bin/docker-entrypoint`), creating/migrating all `solid_*` tables in the same Neon database.

Notes:
- The free Render web service spins down after inactivity and takes ~30-60s to wake up on the next request.
- Solid Queue runs embedded in the Puma process (`SOLID_QUEUE_IN_PUMA=true`) since the free plan only allows one service — no separate worker needed.
- Active Storage is set to `:local` — the container's filesystem is ephemeral on Render, so uploaded files (challenge/submission attachments) will be lost on every redeploy or restart. Switch to a cloud service (e.g. Cloudflare R2, Backblaze B2) before relying on file uploads in production.
