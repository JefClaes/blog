# jefclaes.be

Personal blog built with [Hugo](https://gohugo.io) and the [Ink](https://github.com/knadh/hugo-ink) theme.

## Setup

Clone with submodules to get the theme:

```
git clone --recurse-submodules <repo-url>
```

Or if already cloned:

```
git submodule update --init
```

## Scripts

| Script | Command | Description |
|--------|---------|-------------|
| Serve locally | `.\serve.ps1` | Live-reload dev server at http://localhost:1313 |
| Build | `.\build.ps1` | Generate site into `public/` |
| Test | `.\test.ps1` | Verify `public/` has RSS feed, sitemap, and posts |

## RSS feed

Available at `/feeds/posts/default` (matches the legacy Blogger feed URL).
