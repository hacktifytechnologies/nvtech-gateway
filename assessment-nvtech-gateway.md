# Assessment — NVTech Developer Utility Gateway

---

## Question 1 — MCQ

**Which two reconnaissance sources reveal the existence of the hidden internal bridge endpoint?**

- A) `sitemap.xml` and the application's error logs
- B) The `/api/v1/routes` endpoint and a leaked config file
- C) **`robots.txt` (listing `/dev-utility/bridge/`) and an HTML comment referencing a deprecated JavaScript file** ✅
- D) A DNS TXT record and a `/.well-known/security.txt` file

> **Answer:** C — `robots.txt` disallows `/dev-utility/bridge/` and `/js/deprecated/`. Viewing the homepage source reveals a commented-out `<script>` tag pointing to `/js/deprecated/bridge-test.js`, which when read confirms the internal bridge path and its token requirement.

---

## Question 2 — MCQ

**Why does the standard SQL injection payload `' UNION SELECT ...` fail against the Request Status search field?**

- A) The database does not support UNION-based queries
- B) The application sanitises all single quotes
- C) **The WAF blocks SQL keywords when followed by spaces** ✅
- D) The endpoint only accepts GET requests

> **Answer:** C — The WAF detects keywords like `UNION`, `SELECT`, and `FROM` when they appear with surrounding spaces. The bypass replaces spaces with `/**/` (SQL comment syntax), which is functionally equivalent but evades the space-based pattern match.

---

## Question 3 — MCQ

**What HTTP header is used to authenticate with the internal bridge endpoint after the secret is extracted?**

- A) `Authorization: Bearer <secret>`
- B) `X-Internal-Key: <secret>`
- C) `X-Api-Token: <secret>`
- D) **`X-Bridge-Token: <secret>`** ✅

> **Answer:** D — The internal endpoint `/dev-utility/bridge/sync-v3` requires the `X-Bridge-Token` header containing the secret extracted from the `app_configs` table. Without this header the request is rejected.

---

## Question 4 — Fill in the Blank

**What character sequence replaces spaces in the SQL injection payload to bypass the WAF's space-based keyword detection?**

**Answer:** `/**/`

> The WAF blocks SQL keywords (`UNION`, `SELECT`, `FROM`) when they are surrounded by spaces. Replacing all spaces with `/**/` (an inline SQL comment) produces a syntactically valid query that bypasses the pattern-matching filter, e.g. `'/**/uNiOn/**/sElEcT/**/...`.

---

## Question 5 — Fill in the Blank

**What is the internal configuration secret (`INTERNAL_BRIDGE_SECRET`) extracted from the database via SQL injection?**

**Answer:** `NV-SEC-9921-XP`

> This secret is stored in the `app_configs` table and retrieved using the WAF-bypass UNION SELECT payload. It is then supplied as `X-Bridge-Token: NV-SEC-9921-XP` to access `/dev-utility/bridge/sync-v3?project=HELIX`, which returns the final Master Access Key.

---

*Lab target:* `http://localhost:80`
