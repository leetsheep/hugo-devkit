.DEFAULT_GOAL := dev
.PHONY: dev publish _serve

HUGO_IMAGE ?= ghcr.io/gohugoio/hugo:v0.162.1
HUGO_PORT ?= 1313
LAN_HOST ?= $(shell ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || ifconfig 2>/dev/null | awk '/inet / && $$2 != "127.0.0.1" { print $$2; exit }')
LAN_HOST := $(if $(strip $(LAN_HOST)),$(strip $(LAN_HOST)),0.0.0.0)
GIT_COMMIT ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo unknown)
GIT_STATE ?= $(shell \
	state=""; \
	if ! git diff --cached --quiet --ignore-submodules -- 2>/dev/null; then state="staged changes"; fi; \
	if ! git diff --quiet --ignore-submodules -- 2>/dev/null; then state="$${state:+$$state, }modified files"; fi; \
	if [ -n "$$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then state="$${state:+$$state, }untracked files"; fi; \
	if [ -n "$$state" ]; then printf '%s' "$$state"; else printf clean; fi \
)

PUBLISH_MODE := $(filter publish,$(MAKECMDGOALS))

dev: HOST_BIND := $(if $(PUBLISH_MODE),0.0.0.0,127.0.0.1)
dev: BASE_URL := $(if $(PUBLISH_MODE),http://$(LAN_HOST):$(HUGO_PORT)/,http://localhost:$(HUGO_PORT)/)
dev: _serve

ifeq ($(filter dev,$(MAKECMDGOALS)),dev)
publish:
	@:
else
publish: HOST_BIND := 0.0.0.0
publish: BASE_URL := http://$(LAN_HOST):$(HUGO_PORT)/
publish: _serve
endif

_serve:
	@printf 'Starting Hugo at %s\n' '$(BASE_URL)'
	@docker run --rm -it \
		--user "$$(id -u):$$(id -g)" \
		-e HOME=/tmp \
		-e HUGO_CACHEDIR=/tmp/hugo-cache \
		-e HUGO_GIT_COMMIT="$(GIT_COMMIT)" \
		-e HUGO_GIT_STATE="$(GIT_STATE)" \
		-p "$(HOST_BIND):$(HUGO_PORT):$(HUGO_PORT)" \
		-v "$(CURDIR):/src" \
		-w /src \
		"$(HUGO_IMAGE)" \
		server \
		--bind 0.0.0.0 \
		--port "$(HUGO_PORT)" \
		--baseURL "$(BASE_URL)" \
		--liveReloadPort "$(HUGO_PORT)" \
		--noBuildLock \
		--disableFastRender
