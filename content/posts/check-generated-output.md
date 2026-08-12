+++
title = 'Check the generated output'
description = 'A successful build is the first check, not the last check.'
date = '2026-08-05T09:00:00+02:00'
draft = false
tags = ['output', 'testing']
categories = ['practice']

[[params.references]]
title = 'Hugo command'
url = 'https://gohugo.io/commands/hugo/'

[[params.references]]
title = 'Build options'
url = 'https://gohugo.io/getting-started/usage/'
+++

A production build should fail on template errors. Tests should also confirm
that important pages and assets exist and contain the expected structure.

<!--more-->

The repository runs Hugo in a pinned container. The QA script checks the home
page, guides, paginated list, tag term, feed, sitemap, robots file, JSON output,
alias, processed image, fingerprinted assets, and static file.

Keep checks about behavior, not minified whitespace. HTML formatting may change
without changing the page.
