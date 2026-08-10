# Hugo compatibility suite

This suite determines whether the Hugo image pinned by `HUGO_IMAGE` can render
the project without Hugo errors or semantic regressions. It is intentionally
independent of a CI provider.

## Run the gate

```sh
make test
```

The command needs an OCI-compatible runtime and registry access for the image.
Docker is used by default. Podman and a different artifact directory can be
selected without changing the suite:

```sh
make test \
  CONTAINER_RUNTIME=podman \
  HUGO_TEST_ARTIFACTS=/tmp/hugo-compatibility
```

To evaluate a candidate without editing the Makefile:

```sh
make test HUGO_IMAGE=ghcr.io/gohugoio/hugo:v0.162.1
```

The command returns zero only when production, development, diagnostic, and
development-server profiles behave as expected. Generated logs and JSON reports
are written to `artifacts/hugo-compatibility` by default.

## Gate policy

- Hugo errors, missing output, failed assertions, and server startup failures
  fail the gate.
- Hugo warnings are retained in the logs but remain non-fatal.
- The expected-warning fixture proves that warning policy explicitly.
- The expected-error fixture proves that actual Hugo errors remain fatal.
- Tests do not contact remote resources after the Hugo image is available.

The test site composes `tests` with the existing `example` theme. This exercises
the example theme's Dart Sass and JavaScript pipelines while the test theme adds
deterministic fixtures for multilingual content, page kinds, data formats,
taxonomies, page resources, output formats, and native template APIs.

## Extend coverage

Coverage is declared in
`themes/tests/data/compatibility/coverage.yaml`. Every `required` ID must be
recorded exactly once by a check partial during the build. A missing, duplicate,
or unexpected result is a Hugo error.

Add compatibility behavior in this order:

1. Add a deterministic fixture if the API needs one.
2. Add the coverage entry with a stable ID and responsible partial.
3. Invoke the API and record it with an assertion helper.
4. Run `make test` in both the old and candidate Hugo images when changing the
   coverage baseline.

Experimental, credentialed, destructive, externally tooled, and mutable remote
features use the `excluded` tier and require a concrete reason. Exclusions are
included in the generated report instead of being silently omitted.

## Pipeline integration

GitHub Actions runs the stable `pipeline / test/hugo-compatibility` check for
pull requests and pushes involving `develop` or `main`. Configure that check as
required in branch protection.

Other CI systems should call the same entrypoint. A minimal GitLab-style job is:

```yaml
hugo-compatibility:
  stage: test
  script:
    - make test
  artifacts:
    when: always
    paths:
      - artifacts/hugo-compatibility/
```

The runner must provide Docker, Podman, or an equivalent OCI runtime. Image build
and deployment jobs should depend on this job and must not use an unconditional
execution rule that bypasses a failed compatibility result.

## Renovate promotion

Renovate detects the `HUGO_IMAGE` assignment in the Makefile and opens each Hugo
upgrade against `develop`. Patch, minor, and major updates use platform automerge
with a merge commit. GitHub merges the PR only after all required branch checks
succeed.

Before enabling the Renovate repository, configure these safeguards:

1. Protect `develop` and require `test/hugo-compatibility` plus every other
   mandatory pipeline check.
2. Enable repository auto-merge and the merge-commit strategy.
3. Ensure Renovate configuration is available from the repository's default
   branch so it can discover `baseBranchPatterns: ["develop"]`.

Do not enable platform automerge without at least one required status check.
Renovate documents that GitHub can otherwise merge before tests have completed.
Promotion from `develop` to `main` remains a manual PR guarded by the same test.
