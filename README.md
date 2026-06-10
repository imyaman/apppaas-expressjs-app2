# apppaas-expressjs-app2

Sibling app of `apppaas-expressjs-app1`. Served at a separate URL once deployed.

## Ground rules (shared with app1)

- Repo: `git@github.com:imyaman/apppaas-expressjs-app2.git`
- Deploy flow: push to `origin/main` → server runs `npm install` + `npm run serve -- --host 0.0.0.0`.
- SSH key (for push): `/home/imyaman/cert_banghwa/id_rsa`
- Wiki: `/home/imyaman/knowledge/apppaas/freebuff/`

This repo is intentionally minimal — populate the app code on the next pass.
