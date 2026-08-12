+++
title = 'Resources, Sass, and JavaScript'
description = 'Transform local assets and page resources during the Hugo build.'
weight = 30
tags = ['assets', 'templates']

[[resources]]
  src = 'site-pipeline.jpg'
  title = 'Pages moving through a fast site pipeline'

[[resources]]
  src = 'example-data.json'
  title = 'Example page data'

[[params.references]]
title = 'Resource functions'
url = 'https://gohugo.io/functions/resources/'

[[params.references]]
title = 'Page resources'
url = 'https://gohugo.io/content-management/page-resources/'

[[params.references]]
title = 'Image processing'
url = 'https://gohugo.io/content-management/image-processing/'

[[params.references]]
title = 'Hugo Pipes'
url = 'https://gohugo.io/hugo-pipes/introduction/'

[[params.references]]
title = 'JavaScript building'
url = 'https://gohugo.io/functions/js/build/'

[[params.references]]
title = 'Sass building'
url = 'https://gohugo.io/functions/css/sass/'
+++

Hugo resources are files that Hugo can inspect, transform, fingerprint, and
publish. Use a page resource for a file owned by one page. Use a global resource
from `assets/` when several pages or templates need it.

![Three page cards moving through a fast static-site pipeline.](site-pipeline.jpg "The source image is resized and converted to WebP by a Markdown render hook.")

## Page resources

This page is a leaf bundle. `.Resources.GetMatch` finds its image. The image
render hook creates a 960-pixel WebP and writes its real width and height:

```go-html-template
{{ $resource := .Page.Resources.GetMatch .Destination }}
{{ with $resource }}
  {{ $image := .Resize "960x webp q82" }}
  <img src="{{ $image.RelPermalink }}"
    width="{{ $image.Width }}" height="{{ $image.Height }}" alt="{{ $.Text }}">
{{ end }}
```

The JSON file in this bundle is listed as a download by
`partials/content/resources.html`. Resource metadata in front matter gives it a
useful title.

## Global resources and Hugo Pipes

The theme keeps Sass and JavaScript in `themes/example/assets/`. `main.scss` is
only an entry point. It loads small modules for base rules, layout, content, and
components. `main.js` only starts the code-copy and JavaScript-status modules.
Split a module again when it takes on more than one job.

The copy control keeps its markup in a small component partial. That partial
loads `copy.svg` and `check.svg` from the theme assets. The code-copy module
clones the markup for each code block, writes to the Clipboard API, and briefly
shows the check mark after a successful copy.

The head uses `resources.Get`, `css.Sass`, and `js.Build`. Hugo follows Sass
`@use` rules and JavaScript `import` statements, then makes one browser asset.
Development builds keep source maps and readable output. Production builds
minify and fingerprint files. Development asset URLs include a small content
hash, so live reload does not reuse an old browser cache entry.

The container mounts source files as read-only. `build.noJSConfigInAssets = true`
stops Hugo from writing an editor helper file during the build. A project that
wants Hugo to manage that file can keep the default value.

```go-html-template
{{ with resources.Get "js/main.js" | js.Build $opts | fingerprint }}
  <script defer src="{{ .RelPermalink }}"
    integrity="{{ .Data.Integrity }}" crossorigin="anonymous"></script>
{{ end }}
```

`assets/site.webmanifest` is a global resource too. `resources.ExecuteAsTemplate`
adds the site title and base path before Hugo publishes it.

## Static files

`themes/example/static/example.txt` is copied without a transform. Use `static/`
for files that must keep their exact bytes and path. Prefer `assets/` when Hugo
should process the file.
