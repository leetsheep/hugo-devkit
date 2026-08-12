+++
date = '2026-06-10T00:00:00+02:00'
draft = false
title = 'Start with a small content model'
description = 'Use sections and taxonomies only when readers need them.'
tags = ['content', 'structure']
categories = ['practice']

[[params.references]]
title = 'Content organization'
url = 'https://gohugo.io/content-management/organization/'

[[params.references]]
title = 'Taxonomies'
url = 'https://gohugo.io/content-management/taxonomies/'
+++

Hugo makes folders, sections, and taxonomies easy to add. That does not mean a
site needs many of them. Begin with normal pages. Add a section when a group of
pages needs its own list page. Add a taxonomy when readers need to move across
sections by topic.

<!--more-->

This file is a regular content page:

```text
content/posts/example-post.md
```

The parent `content/posts/_index.md` creates the section page. The `tags` and
`categories` fields create taxonomy links and term pages.
