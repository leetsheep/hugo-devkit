+++
title = 'Configuration, data, and languages'
description = 'Keep site settings, reusable records, and interface messages out of page bodies.'
weight = 40
tags = ['data', 'configuration']
+++

Content is for page text. Configuration, shared records, and interface messages
have better homes.

## Site configuration

The root `hugo.toml` sets the base URL, language, menus, taxonomies, outputs,
pagination, related-content rules, and safe environment access. Templates read
these values from `site`.

```go-html-template
<a href="{{ site.Home.RelPermalink }}">{{ site.Title }}</a>
```

Put site-specific settings in the project. Put reusable theme defaults in theme
files. Split configuration under `config/_default/` only when one file becomes
hard to scan or environments need clear overrides.

## Data files

The guide cards on the home page come from
`themes/example/data/example_features.yaml`. The template reads the merged data
store with `hugo.Data.example_features`, resolves each `pageRef`, and lets the
page stay the source of its title and description.

```go-html-template
{{ range hugo.Data.example_features }}
  {{ with site.GetPage .pageRef }}
    {{ partial "content/card.html" . }}
  {{ end }}
{{ end }}
```

Use data files for structured records shared by pages. Do not copy a page into a
data file.

## Interface messages

`themes/example/i18n/en.yaml` and `de.yaml` hold short interface messages. The
template calls `i18n "skip_to_content"`. Content stays in its content file; UI
labels stay in the language catalog.

The example publishes English only, so it does not duplicate every guide. Add a
language in `hugo.toml` and a matching content tree when the site has translated
content. Hugo then builds one site per language and links translations.

## Build environment

The asset partials use `hugo.IsDevelopment` to select source maps or production
fingerprints. The footer reads build values allowed by `[security.funcs]`. Keep
secrets out of templates and generated output.

## References

- [Configure Hugo](https://gohugo.io/configuration/)
- [Data sources](https://gohugo.io/content-management/data-sources/)
- [Multilingual sites](https://gohugo.io/content-management/multilingual/)
- [Internationalization](https://gohugo.io/functions/lang/translate/)
- [Security model](https://gohugo.io/about/security-model/)
