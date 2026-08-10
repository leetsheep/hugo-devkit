#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
CONTAINER_RUNTIME=${CONTAINER_RUNTIME:-docker}
HUGO_IMAGE=${HUGO_IMAGE:?HUGO_IMAGE must name the Hugo OCI image to test}
HUGO_TEST_ARTIFACTS=${HUGO_TEST_ARTIFACTS:-"$REPOSITORY_ROOT/artifacts/hugo-compatibility"}
FIXTURE_ROOT=/src/tests/fixtures/site
SERVER_CONTAINER=

if ! command -v "$CONTAINER_RUNTIME" >/dev/null 2>&1; then
  printf 'error: container runtime %s is not available\n' "$CONTAINER_RUNTIME" >&2
  exit 1
fi

TEMPORARY_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/hugo-compatibility.XXXXXX")

cleanup() {
  if [ -n "$SERVER_CONTAINER" ]; then
    "$CONTAINER_RUNTIME" rm -f "$SERVER_CONTAINER" >/dev/null 2>&1 || true
  fi
  rm -rf "$TEMPORARY_ROOT"
}

trap cleanup EXIT HUP INT TERM

mkdir -p "$HUGO_TEST_ARTIFACTS"
rm -f \
  "$HUGO_TEST_ARTIFACTS/production.log" \
  "$HUGO_TEST_ARTIFACTS/production.json" \
  "$HUGO_TEST_ARTIFACTS/development.log" \
  "$HUGO_TEST_ARTIFACTS/development.json" \
  "$HUGO_TEST_ARTIFACTS/server.log" \
  "$HUGO_TEST_ARTIFACTS/warning.log" \
  "$HUGO_TEST_ARTIFACTS/expected-error.log"

run_build() {
  environment=$1
  output_directory=$2
  log_file=$3
  diagnostic=${4:-}

  resource_directory="$TEMPORARY_ROOT/resources-$environment-$$"
  mkdir -p "$output_directory" "$resource_directory"

  if ! "$CONTAINER_RUNTIME" run --rm \
    --user "$(id -u):$(id -g)" \
    -e HOME=/tmp \
    -e HUGO_CACHEDIR=/tmp/hugo-cache \
    -e HUGO_COMPATIBILITY_SENTINEL=available \
    -e HUGO_PARAMS_COMPATIBILITYDIAGNOSTIC="$diagnostic" \
    -e HUGO_RESOURCEDIR=/resources \
    -v "$REPOSITORY_ROOT:/src:ro" \
    -v "$output_directory:/output" \
    -v "$resource_directory:/resources" \
    -w "$FIXTURE_ROOT" \
    "$HUGO_IMAGE" build \
    --destination /output \
    --environment "$environment" \
    --noBuildLock \
    --logLevel info \
    --printI18nWarnings \
    --printPathWarnings \
    --printUnusedTemplates >"$log_file" 2>&1; then
    printf 'error: Hugo %s build failed\n' "$environment" >&2
    cat "$log_file" >&2
    return 1
  fi

  cat "$log_file"
}

assert_file() {
  if [ ! -s "$1" ]; then
    printf 'error: expected generated file %s\n' "$1" >&2
    return 1
  fi
}

assert_contains() {
  file=$1
  pattern=$2
  if ! grep -E "$pattern" "$file" >/dev/null 2>&1; then
    printf 'error: %s does not contain %s\n' "$file" "$pattern" >&2
    return 1
  fi
}

validate_output() {
  output_directory=$1
  report_destination=$2

  assert_file "$output_directory/index.html"
  assert_file "$output_directory/de/index.html"
  assert_file "$output_directory/404.html"
  assert_file "$output_directory/compatibility.json"
  assert_file "$output_directory/company/index.html"
  assert_file "$output_directory/journal/first-post/index.html"
  assert_file "$output_directory/shortcodes/index.html"
  assert_file "$output_directory/static-fixture.txt"
  assert_file "$output_directory/tags/hugo/index.html"
  assert_file "$output_directory/compatibility/copied.txt"
  assert_file "$output_directory/compatibility/templated.txt"
  assert_file "$output_directory/compatibility/fixture.css"
  assert_file "$output_directory/compatibility/fixture.js"

  assert_contains "$output_directory/index.html" 'data-compatibility-suite'
  assert_contains "$output_directory/de/index.html" 'Kompatibilit.t'
  assert_contains "$output_directory/journal/first-post/index.html" 'data-compatibility-render-hook'
  assert_contains "$output_directory/shortcodes/index.html" 'data-compatibility-shortcode'
  assert_contains "$output_directory/compatibility.json" '"status"[[:space:]]*:[[:space:]]*"pass"'
  assert_contains "$output_directory/compatibility.json" '"requiredCount"[[:space:]]*:'

  cp "$output_directory/compatibility.json" "$report_destination"
}

production_output="$TEMPORARY_ROOT/production"
run_build production "$production_output" "$HUGO_TEST_ARTIFACTS/production.log"
validate_output "$production_output" "$HUGO_TEST_ARTIFACTS/production.json"

development_output="$TEMPORARY_ROOT/development"
run_build development "$development_output" "$HUGO_TEST_ARTIFACTS/development.log"
validate_output "$development_output" "$HUGO_TEST_ARTIFACTS/development.json"

warning_output="$TEMPORARY_ROOT/warning"
run_build production "$warning_output" "$HUGO_TEST_ARTIFACTS/warning.log" warning
assert_contains "$HUGO_TEST_ARTIFACTS/warning.log" '\[compatibility:expected-warning\]'

error_output="$TEMPORARY_ROOT/expected-error"
error_resources="$TEMPORARY_ROOT/resources-expected-error"
mkdir -p "$error_output" "$error_resources"
if "$CONTAINER_RUNTIME" run --rm \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -e HUGO_CACHEDIR=/tmp/hugo-cache \
  -e HUGO_COMPATIBILITY_SENTINEL=available \
  -e HUGO_PARAMS_COMPATIBILITYDIAGNOSTIC=error \
  -e HUGO_RESOURCEDIR=/resources \
  -v "$REPOSITORY_ROOT:/src:ro" \
  -v "$error_output:/output" \
  -v "$error_resources:/resources" \
  -w "$FIXTURE_ROOT" \
  "$HUGO_IMAGE" build \
  --destination /output \
  --environment production \
  --noBuildLock \
  >"$HUGO_TEST_ARTIFACTS/expected-error.log" 2>&1; then
  printf 'error: expected-error fixture unexpectedly succeeded\n' >&2
  exit 1
fi
assert_contains "$HUGO_TEST_ARTIFACTS/expected-error.log" '\[compatibility:expected-error\]'

SERVER_CONTAINER="hugo-compatibility-$$"
server_resources="$TEMPORARY_ROOT/resources-server"
mkdir -p "$server_resources"
"$CONTAINER_RUNTIME" run -d \
  --name "$SERVER_CONTAINER" \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -e HUGO_CACHEDIR=/tmp/hugo-cache \
  -e HUGO_COMPATIBILITY_SENTINEL=available \
  -e HUGO_PARAMS_COMPATIBILITYMODE=server \
  -e HUGO_RESOURCEDIR=/resources \
  -v "$REPOSITORY_ROOT:/src:ro" \
  -v "$server_resources:/resources" \
  -w "$FIXTURE_ROOT" \
  "$HUGO_IMAGE" server \
  --bind 0.0.0.0 \
  --disableFastRender \
  --environment development \
  --noBuildLock \
  --port 1313 \
  --renderToMemory \
  >/dev/null

server_ready=false
attempt=0
while [ "$attempt" -lt 30 ]; do
  "$CONTAINER_RUNTIME" logs "$SERVER_CONTAINER" >"$HUGO_TEST_ARTIFACTS/server.log" 2>&1 || true
  if grep -E 'Web Server is available|Press Ctrl.C to stop' "$HUGO_TEST_ARTIFACTS/server.log" >/dev/null 2>&1; then
    server_ready=true
    break
  fi
  if [ "$("$CONTAINER_RUNTIME" inspect -f '{{.State.Running}}' "$SERVER_CONTAINER" 2>/dev/null || printf false)" != true ]; then
    break
  fi
  attempt=$((attempt + 1))
  sleep 1
done

if [ "$server_ready" != true ]; then
  printf 'error: Hugo development server did not become ready\n' >&2
  cat "$HUGO_TEST_ARTIFACTS/server.log" >&2
  exit 1
fi

"$CONTAINER_RUNTIME" rm -f "$SERVER_CONTAINER" >/dev/null
SERVER_CONTAINER=

printf 'Hugo compatibility checks passed for %s\n' "$HUGO_IMAGE"
printf 'Artifacts: %s\n' "$HUGO_TEST_ARTIFACTS"
