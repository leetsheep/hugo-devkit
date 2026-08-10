{
  "title": "Write useful front matter",
  "description": "Store facts templates use; keep prose in the page body.",
  "date": "2026-07-22T09:00:00+02:00",
  "draft": false,
  "tags": ["content", "data"],
  "categories": ["practice"]
}

Front matter should be small and predictable. A title, description, date, and a
few stable terms are enough for many pages.

<!--more-->

This file uses JSON front matter to prove Hugo reads it. The site also contains
TOML and YAML front matter. A normal project should use one house style so diffs
stay easy to read.

Do not put full reusable records into page parameters. Put shared structured
records in `data/`, and keep page prose in the Markdown body.

## References

- [Front matter](https://gohugo.io/content-management/front-matter/)
- [Data sources](https://gohugo.io/content-management/data-sources/)
