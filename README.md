# Alcock.net

The web home of the **Alcock** surname, and of one Alcock in particular.

## The sites

**[alcock.net](https://alcock.net)** is a small heritage site for the name:
its Middle English origins ("little Al," on the record since 1275), the
remarkable people who have carried it — a bishop who founded a Cambridge
college, the man who invented the FA Cup, and the first aviators to fly the
Atlantic nonstop — and the five-hundred-year-old rooster rebus that serves
as its badge. Alcocks anywhere can request a **you@alcock.net** address or a
**you.alcock.net** page: [alcock.net/join](https://alcock.net/join.html).

**[jason.alcock.net](https://jason.alcock.net)** is the personal site of the
domain's keeper: quality engineering, learning projects, and a resume with
the full journey from a 300 baud modem in 1980 to agentic testing today.

## How it's built

Plain static HTML and CSS. No build step, no JavaScript, no frameworks, no
trackers, no cookies. Two stylesheets share one visual family: parchment
and heraldic red for the heritage site, a dark cousin for the personal one.

- `site/` — docroot for alcock.net (four pages)
- `jason/` — docroot for jason.alcock.net (home + resume)

Portraits and heraldry come from Wikimedia Commons; every image carries its
license and credit on the page where it appears.

## Deployment

Pushes to `main` run a GitHub Actions workflow: validate HTML and internal
links, mirror both docroots to the web server, then verify the live pages.
`deploy.sh` is the manual fallback; it stores no credentials. See
`DEPLOY.md` for details.

## Contact

Site matters, corrections, or a claim to the name: **admin@alcock.net**.

Text © Jason Alcock. Image rights remain with their credited sources.
