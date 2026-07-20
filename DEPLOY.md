# Deploying alcock.net + jason.alcock.net

Two static sites, no build step, same Dreamhost VPS as the other projects.

**Primary deploy path: GitHub Actions.** Pushing to `main` on
github.com/j-alcock/alcock.net runs `.github/workflows/deploy.yml`:
validate HTML → lftp mirror both docroots → curl-verify the live pages.
Requires repo secrets `DREAMHOST_HOST`, `DREAMHOST_USER`, `DREAMHOST_PASS`
(already configured); optional `DREAMHOST_PATH_MAIN` / `DREAMHOST_PATH_JASON`
override the default docroots `~/alcock.net` and `~/jason.alcock.net`.
`deploy.sh` below remains as the manual fallback.

Site contact address is **admin@alcock.net** (jason@alcock.net stays personal,
listed in the member register).

- `site/` → docroot for **alcock.net** (4 pages + css + rooster.svg)
- `jason/` → docroot for **jason.alcock.net** (1 page + css + rooster.svg)

## One-time Dreamhost setup

1. **Panel → Websites → Manage Websites → Add Website**: add `alcock.net`
   (with `www` redirect) as *Static* hosting on the VPS user of your choice.
   Docroot convention: `/home/<user>/alcock.net`.
2. Repeat for the subdomain: add `jason.alcock.net` as its own fully hosted
   site with docroot `/home/<user>/jason.alcock.net`. (Dreamhost treats
   subdomains as separate sites; DNS A records are added automatically when
   the domain's DNS is at Dreamhost.)
3. Enable **HTTPS (Let's Encrypt)** for both in the panel once they resolve.
4. Email `jason@alcock.net` presumably already exists; future member
   addresses are added under Panel → Mail.

## Deploy

Edit the config block at the top of `deploy.sh` (set `VPS_HOST`, `VPS_USER`;
confirm the two web roots), then:

```sh
./deploy.sh --dry-run   # preview what would transfer
./deploy.sh             # deploy both sites; password prompted interactively
```

Same rules as ourqa-site: rsync with scp fallback, no stored credentials
anywhere, the script never reads a password.

## Post-deploy checks

- <https://alcock.net> renders the parchment theme with the rooster; nav
  reaches all four pages; if you see a directory listing the docroot is wrong.
- <https://jason.alcock.net> renders the dark theme.
- The mailto buttons on `join.html` open drafts to `jason@alcock.net` with
  prefilled subjects.
- Cross-links work both ways (footer of each site links to the other).
- Looks right on a phone.

## Adding a member later

1. Add a row to the table in `site/join.html`.
2. If they want `name.alcock.net`: add the subdomain in the panel pointing at
   their page (or a redirect to their existing site), or use Panel → DNS for
   a CNAME if they host elsewhere.
3. Add `name@alcock.net` under Panel → Mail.
