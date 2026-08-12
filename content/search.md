+++
title = 'Search'
description = 'Search guides, posts, and reference pages.'
layout = 'search'

[params]
searchExclude = true

[[params.references]]
title = 'Configure output formats'
url = 'https://gohugo.io/configuration/output-formats/'

[[params.references]]
title = 'JSON encoding'
url = 'https://gohugo.io/functions/encoding/jsonify/'

[[params.references]]
title = 'Plain page content'
url = 'https://gohugo.io/methods/page/plain/'

[[params.references]]
title = 'JavaScript building'
url = 'https://gohugo.io/functions/js/build/'
+++

Hugo does not include a search engine. It can build `search-index.json` from
regular pages. The search module downloads that file only on this page and
filters it in the browser. No search service or third-party library is required.

## Enable the index

Add `searchIndex` to `outputs.home`, then define the output format in
`hugo.toml`. The template `themes/example/layouts/home.searchindex.json` uses
`.Plain` and `jsonify` to create safe JSON.

## Use the search

`themes/example/layouts/search.html` provides the form and the index URL. The
small `themes/example/assets/js/features/search.js` module loads the index after
a search, matches all query words, and creates result links with browser DOM
APIs. Set `params.searchExclude = true` on a page that should not appear in
results.
