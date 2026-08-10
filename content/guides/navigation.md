+++
title = 'Menus, taxonomies, and page collections'
description = 'Help readers move through pages with Hugo collections and relationships.'
weight = 50
tags = ['navigation', 'content']
+++

Navigation should follow the content model. Hugo already knows page parents,
sections, menu entries, taxonomy terms, and related pages.

## Menus

The main menu is defined in `hugo.toml` with `pageRef`. A page reference is safer
than a hand-written URL because Hugo resolves the final permalink.

```toml
[[menus.main]]
  name = 'Guides'
  pageRef = '/guides'
  weight = 10
```

`partials/navigation/menu.html` ranges over `site.Menus.main` and uses
`.IsMenuCurrent` and `.HasMenuCurrent` for the current state.

## Breadcrumbs and section links

The breadcrumb partial uses `.Ancestors.Reverse`. The page navigation uses
`.NextInSection` and `.PrevInSection`. These methods use the page tree instead of
repeating paths in front matter.

## Taxonomies

Posts and guides have tags. Hugo creates `/tags/` and one term page per tag. The
theme keeps the two page kinds clear:

- `taxonomy.html` lists terms and their page counts;
- `term.html` lists pages for one term.

Add a taxonomy only when it helps readers find related work. Use a few stable
terms instead of many one-page terms.

## Pagination

Section and term templates call `.Paginate` once, then render Hugo's embedded
pagination partial. `pagination.pagerSize = 4` makes the example visible with a
small number of posts. Real sites should choose a size for their content and
page weight.

## Related content

The page template calls `site.RegularPages.Related .`. Rules in `hugo.toml` give
tags most of the weight and dates a small weight. Related results are useful only
when the source metadata is consistent.

## References

- [Menus](https://gohugo.io/content-management/menus/)
- [Taxonomies](https://gohugo.io/content-management/taxonomies/)
- [Pagination](https://gohugo.io/templates/pagination/)
- [Related content](https://gohugo.io/content-management/related/)
- [Page collections](https://gohugo.io/quick-reference/page-collections/)
