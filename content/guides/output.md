+++
title = 'Output formats and generated files'
description = 'Publish HTML, feeds, data, redirects, search files, and error pages.'
weight = 60
tags = ['output', 'templates']
+++

One Hugo page can produce more than HTML. Keep the default output when it works.
Add a custom output only for a real consumer.

## HTML, RSS, sitemap, and robots

`hugo.toml` enables HTML and RSS for list pages. The head gets the current RSS
output with `.OutputFormats.Get "rss"` and adds a discovery link. Hugo's embedded
RSS template writes each feed.

`enableRobotsTXT = true` creates `/robots.txt`. Hugo also creates
`/sitemap.xml`. The example does not override these templates because the native
defaults are correct for a normal site.

## A custom JSON output

The `guideIndex` output format publishes `/guides.json` from
`layouts/home.guideindex.json`. The template builds plain records and passes the
result to `jsonify` once.

```toml
[outputFormats.guideIndex]
  baseName = 'guides'
  isPlainText = true
  mediaType = 'application/json'
  notAlternative = true
```

JSON templates must return valid JSON for empty strings, quotes, and Unicode.
Build maps or slices, then use `jsonify`; do not join JSON by hand.

## Aliases and 404 pages

This page's content guide has an alias from `/guides/pages/`. Hugo writes a
redirect page for the old path. Aliases help moved content; they are not a
replacement for server redirects when HTTP status codes matter.

`themes/example/layouts/404.html` uses the shared base template and gives the
reader a route home. The hosting service must serve the generated `404.html`.

## Drafts and future content

Hugo excludes drafts, future pages, and expired pages in a normal production
build. Use server flags to preview them. Keep those flags out of the production
command.

## References

- [Output formats](https://gohugo.io/configuration/output-formats/)
- [RSS templates](https://gohugo.io/templates/rss/)
- [Sitemap templates](https://gohugo.io/templates/sitemap/)
- [Robots templates](https://gohugo.io/templates/robots/)
- [Aliases](https://gohugo.io/content-management/urls/#aliases)
- [404 templates](https://gohugo.io/templates/404/)
