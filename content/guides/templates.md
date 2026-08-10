+++
title = 'Templates and Markdown hooks'
description = 'Compose page-kind templates, partials, shortcodes, and render hooks.'
weight = 20
tags = ['templates', 'content']
+++

Templates turn content and data into output. The example theme uses the current
page-kind names: `home.html`, `page.html`, `section.html`, `taxonomy.html`, and
`term.html`.

## Base templates and blocks

`themes/example/layouts/baseof.html` owns the shared document. Page templates
only define the main block.

```go-html-template
{{ define "main" }}
  <article class="content">
    <h1>{{ .Title }}</h1>
    {{ .Content }}
  </article>
{{ end }}
```

This keeps the document shell in one place and lets Hugo's lookup rules select
the page-specific template.

## Context

The dot is the current context. Inside `range` it changes to the current item.
Pass context to a partial on purpose:

```go-html-template
{{ partial "content/card.html" . }}
```

Use `$` only when code inside `with` or `range` needs the context captured at
the start of the template. Small partials make context easier to see.

## Partials and cached partials

The theme groups partials by job: `assets`, `content`, and `navigation`. The CSS
and JavaScript partials use `partialCached` because their result is the same for
every page in one build. Do not cache a partial that depends on page data unless
the page is part of its cache key.

## Markdown render hooks

Files under `layouts/_markup/` control headings, links, and images produced from
Markdown. This theme:

- adds a stable link to each heading;
- marks absolute links as external without forcing a new tab;
- finds a local image page resource and asks Hugo to create a smaller WebP.

Render hooks keep author Markdown clean. The resource guide uses the image hook
with normal Markdown image syntax.

## Embedded templates

The head calls Hugo's embedded Open Graph and Schema partials. List pages call
the embedded pagination partial. RSS and sitemap files also use Hugo defaults.
Override an embedded template only when the site has a clear need.

## References

- [Introduction to templating](https://gohugo.io/templates/introduction/)
- [Template lookup order](https://gohugo.io/templates/lookup-order/)
- [Partial templates](https://gohugo.io/templates/partials/)
- [Render hooks](https://gohugo.io/render-hooks/)
- [Embedded templates](https://gohugo.io/templates/embedded/)
