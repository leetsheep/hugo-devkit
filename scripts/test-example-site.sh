#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
CONTAINER_RUNTIME=${CONTAINER_RUNTIME:-docker}
HUGO_IMAGE=${HUGO_IMAGE:?HUGO_IMAGE must name the Hugo OCI image to test}
HUGO_TEST_ARTIFACTS=${HUGO_TEST_ARTIFACTS:-"$REPOSITORY_ROOT/artifacts/hugo-compatibility"}

if ! command -v "$CONTAINER_RUNTIME" >/dev/null 2>&1; then
  printf 'error: container runtime %s is not available\n' "$CONTAINER_RUNTIME" >&2
  exit 1
fi

TEMPORARY_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/hugo-example.XXXXXX")
OUTPUT_ROOT="$TEMPORARY_ROOT/public"
RESOURCE_ROOT="$TEMPORARY_ROOT/resources"
LOG_FILE="$HUGO_TEST_ARTIFACTS/example.log"

cleanup() {
  rm -rf "$TEMPORARY_ROOT"
}

trap cleanup EXIT HUP INT TERM

mkdir -p "$HUGO_TEST_ARTIFACTS" "$OUTPUT_ROOT" "$RESOURCE_ROOT"
rm -f "$LOG_FILE"

if ! "$CONTAINER_RUNTIME" run --rm \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -e HUGO_CACHEDIR=/tmp/hugo-cache \
  -e HUGO_GIT_COMMIT=test \
  -e HUGO_GIT_STATE=clean \
  -e HUGO_RESOURCEDIR=/resources \
  -v "$REPOSITORY_ROOT:/src:ro" \
  -v "$OUTPUT_ROOT:/output" \
  -v "$RESOURCE_ROOT:/resources" \
  -w /src \
  "$HUGO_IMAGE" build \
  --baseURL https://example.org/ \
  --destination /output \
  --environment production \
  --minify \
  --noBuildLock \
  --printI18nWarnings \
  --printPathWarnings >"$LOG_FILE" 2>&1; then
  printf 'error: example site build failed\n' >&2
  cat "$LOG_FILE" >&2
  exit 1
fi

cat "$LOG_FILE"

assert_file() {
  if [ ! -s "$OUTPUT_ROOT/$1" ]; then
    printf 'error: expected generated file %s\n' "$OUTPUT_ROOT/$1" >&2
    exit 1
  fi
}

assert_contains() {
  file=$1
  pattern=$2

  if ! grep -E "$pattern" "$OUTPUT_ROOT/$file" >/dev/null 2>&1; then
    printf 'error: %s does not contain %s\n' "$OUTPUT_ROOT/$file" "$pattern" >&2
    exit 1
  fi
}

assert_generated_asset() {
  directory=$1
  pattern=$2

  if ! find "$OUTPUT_ROOT/$directory" -maxdepth 1 -type f -name "$pattern" -size +0c | grep . >/dev/null 2>&1; then
    printf 'error: expected generated asset %s/%s\n' "$OUTPUT_ROOT/$directory" "$pattern" >&2
    exit 1
  fi
}

for path in \
  404.html \
  example.txt \
  guides.json \
  guides/content/index.html \
  guides/navigation/index.html \
  guides/output/index.html \
  guides/pages/index.html \
  guides/resources/example-data.json \
  guides/resources/index.html \
  guides/site-data/index.html \
  guides/templates/index.html \
  index.html \
  index.xml \
  posts/page/2/index.html \
  references/index.html \
  robots.txt \
  site.webmanifest \
  sitemap.xml \
  tags/content/index.html
do
  assert_file "$path"
done

for page in \
  index.html \
  guides/index.html \
  guides/content/index.html \
  guides/navigation/index.html \
  guides/output/index.html \
  guides/resources/index.html \
  guides/site-data/index.html \
  guides/templates/index.html \
  posts/index.html
do
  assert_contains "$page" 'class=references'
  assert_contains "$page" 'class=heading-link href=#references'
done

assert_contains index.html 'Feature guides'
assert_contains index.html 'callout--note'
assert_contains guides.json '"guides"'
assert_contains guides.json '"version":"[0-9]'
assert_contains guides/resources/index.html '\.webp'
assert_contains guides/resources/index.html 'example-data\.json'
assert_contains posts/index.html 'posts/page/2/'
if [ "$(grep -o 'class=card' "$OUTPUT_ROOT/posts/index.html" | wc -l | tr -d ' ')" -ne 4 ]; then
  printf 'error: first posts page does not contain four items\n' >&2
  exit 1
fi
assert_contains 404.html 'Page not found'
assert_contains guides/pages/index.html 'guides/content/'
assert_contains site.webmanifest '"name": "Hugo Devkit"'

assert_generated_asset css 'main.*.css'
assert_generated_asset js 'main.*.js'
assert_generated_asset guides/resources '*.webp'

if grep -E '(^|[[:space:]])(WARN|ERROR)([[:space:]]|$)' "$LOG_FILE" >/dev/null 2>&1; then
  printf 'error: example build emitted a warning or error\n' >&2
  exit 1
fi

printf 'Example site checks passed for %s\n' "$HUGO_IMAGE"
