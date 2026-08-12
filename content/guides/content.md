---
title: "Content, front matter, and bundles"
description: "Model pages with sections, front matter, summaries, and page bundles."
weight: 10
aliases:
  - /guides/pages/
tags:
  - content
  - structure
params:
  references:
    - title: Content management
      url: https://gohugo.io/content-management/
    - title: Front matter
      url: https://gohugo.io/content-management/front-matter/
    - title: Page bundles
      url: https://gohugo.io/content-management/page-bundles/
    - title: Archetypes
      url: https://gohugo.io/content-management/archetypes/
    - title: Shortcodes
      url: https://gohugo.io/content-management/shortcodes/
---

Hugo reads content from `content/`. The folder path gives a page its section.
Use front matter for facts about the page, not for text that belongs in the
body.

## Front matter

This page uses YAML front matter. Other pages in this site use TOML and JSON.
Choose one format for a real project unless an integration requires another.

```yaml
---
title: "Content, front matter, and bundles"
description: "Model pages with sections, front matter, summaries, and page bundles."
weight: 10
tags:
  - content
---
```

Hugo has standard fields such as `title`, `date`, `draft`, `weight`, `aliases`,
and `outputs`. Put custom values under `params` when they are not built in.

## Branch and leaf bundles

An `_index.md` file creates a branch bundle. It can have child pages. An
`index.md` file creates a leaf bundle. Keep files used by one page beside that
page.

```text
content/
├── guides/
│   ├── _index.md
│   └── resources/
│       ├── index.md
│       └── site-pipeline.jpg
└── posts/
    └── _index.md
```

The resources guide is a leaf bundle. Its image is a page resource, so the
theme can resize it.

## Summaries and tables of contents

Hugo can create an automatic summary. Add `<!--more-->` when the cut must be
exact. The page template reads `.Summary`, `.ReadingTime`, and
`.TableOfContents`; Hugo calculates them from the content.

## Archetypes

Run `hugo new content posts/my-post.md`. Hugo uses
`themes/example/archetypes/posts.md` for the initial fields and body. The
project-level `archetypes/default.md` shows how a project can override a theme
default.

Archetypes are a starting point. They should make the safe path easy: new posts
are drafts, have an empty tag list, and ask for a short summary.

## Shortcodes

The callout on the home page comes from
`themes/example/layouts/_shortcodes/callout.html`. A shortcode is useful when
content authors need a stable component. Keep normal Markdown as the default.
