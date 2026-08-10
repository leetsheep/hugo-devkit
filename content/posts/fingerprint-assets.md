+++
title = 'Fingerprint production assets'
description = 'Give browsers a stable file in development and an immutable file in production.'
date = '2026-07-08T09:00:00+02:00'
draft = false
tags = ['assets', 'output']
categories = ['practice']
+++

Hugo can hash an asset after it builds and minifies it. The hash changes when
the file changes, so long browser cache times are safe.

<!--more-->

The example also writes the integrity value to the HTML tag. Development builds
skip the fingerprint and keep source maps, which makes local work easier.

Keep this decision in one asset partial. Page templates should not repeat the
pipeline.

## References

- [Fingerprint resources](https://gohugo.io/functions/resources/fingerprint/)
- [Asset management](https://gohugo.io/content-management/asset-management/)
