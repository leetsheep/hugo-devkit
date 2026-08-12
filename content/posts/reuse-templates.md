---
title: "Reuse templates at clear boundaries"
description: "Use a partial when several templates share one rendering job."
date: 2026-06-24T09:00:00+02:00
draft: false
tags:
  - templates
  - structure
categories:
  - practice
params:
  references:
    - title: Partial templates
      url: https://gohugo.io/templates/partials/
    - title: Template introduction
      url: https://gohugo.io/templates/introduction/
---

A partial should have one clear job and a clear context. This makes it easy to
reuse and test.

<!--more-->

This theme uses `content/card.html` from the home, section, and term templates.
Each call passes one Page, so the partial does not need a custom dictionary.

Use a dictionary when the partial needs several named values. Avoid passing a
large context only because it is available.
