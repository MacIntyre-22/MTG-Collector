# cardhold.ca — static site

This folder is the **entire** static site for Cardhold. It has no backend and never talks to the main
server or to CloudKit. It serves the marketing home page, the privacy and support pages, proves domain
ownership to Apple via the AASA file, and shows a "get the app" page to people who tap a share link
without Cardhold installed. The actual shared decks live in CloudKit and are read directly by the app.

## Files

| File | Purpose |
|---|---|
| `index.html` | Marketing home page, served at the root domain. |
| `share.html` | "Get the app" page for shared links (shown only to non-installers), served at `/share`. |
| `privacy.html` / `support.html` | Privacy policy and support pages. |
| `.well-known/apple-app-site-association` | Apple's app-link ownership/verification file. Maps `/share/*` to the app. |
| `_redirects` | Cloudflare Pages: rewrite `/share/<id>` → `share.html` (200), and `/marketing` → `/` (301). |
| `_headers` | Cloudflare Pages: serve the AASA file as `application/json`. |

## Before deploying — fill in two placeholders

1. **`__APPLE_TEAM_ID__`** in `.well-known/apple-app-site-association`
   Your 10-character Apple Developer Team ID (developer.apple.com → Membership). The final value
   is `<TeamID>.net.benmacintyre.cardhold`.

2. **`__APP_STORE_ID__`** in `index.html` and `share.html`
   The numeric App Store ID for Cardhold. You won't have this until the app is created in App
   Store Connect — until then the App Store button just won't resolve, which is fine for testing.

## Deploy (Cloudflare Pages)

1. Create a Cloudflare Pages project and upload this `web/` folder (or connect the repo and set the
   build output directory to `web`). No build command needed — it's static.
2. In Pages → Custom domains, add **`cardhold.ca`**. Cloudflare will tell you the DNS
   record to add (a CNAME). This points the subdomain at Pages only — your main server is untouched.
3. Cloudflare issues the HTTPS cert automatically.

## Verify

- `https://cardhold.ca/.well-known/apple-app-site-association` returns the JSON over
  HTTPS, as `application/json`, with **no redirect**.
- `https://cardhold.ca/` shows the marketing home page.
- `https://cardhold.ca/share/anything` shows the "get the app" page.

## Matching app-side setup (not in this folder)

- Xcode → Signing & Capabilities → Associated Domains: `applinks:cardhold.ca`
- Xcode → iCloud/CloudKit container: `iCloud.net.benmacintyre.cardhold`
- The app mints links as `https://cardhold.ca/share/<id>` (CollectionShareService).

iOS caches the AASA per app install — delete and reinstall the app to force a re-fetch while testing.
