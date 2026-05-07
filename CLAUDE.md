# Blog — jefclaes.be

Personal blog built with [Hugo](https://gohugo.io/) and the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme. Content covers software engineering, DDD, event sourcing, and personal topics.

## Commands

```powershell
.\build.ps1   # Build into public/ (minified, clean)
.\serve.ps1   # Run locally at http://localhost:1313 with live reload (includes drafts)
.\test.ps1    # Verify the build output (RSS, sitemap, homepage, post pages)
```

Run `.\build.ps1` before `.\test.ps1` — the test script checks `public/`.

## Structure

- `content/post/` — all blog posts (235 markdown files, 2009–2018)
- `layouts/index.rss` — custom RSS template; keeps the feed at `/feeds/posts/default` for Feedburner/legacy subscriber compatibility
- `themes/PaperMod/` — theme submodule, do not edit directly
- `config.toml` — site config: theme, menus, social icons, RSS output format, permalink pattern

## Content front matter

Posts use TOML front matter with `published` (not `date`) as the date field and a `url` field that preserves original Blogger-era URLs:

```toml
+++
title = "Post title"
published = 2015-04-01T10:00:00+01:00
tags = [ "code" ]
url = "2015/04/post-slug.html"
+++
```

The `url` field is intentional — it keeps old URLs working so inbound links don't break.

## Theme

PaperMod is installed as a git submodule at `themes/PaperMod`. To update it:

```powershell
git submodule update --remote --merge
```
