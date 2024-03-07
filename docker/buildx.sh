#!/usr/bin/env bash

command -v docker >/dev/null 2>&1 || {
    echo "Docker is not running. Please start Docker and try again."
    exit 1
}

SCRIPT_DIR="$(readlink -f "$(dirname "$0")")"
MONOREPO_ROOT="$(readlink -f "$SCRIPT_DIR/../")"

APP_VERSION="$(git name-rev --tags --name-only $(git rev-parse HEAD) | head -n 1 | sed 's/\^0//')"
GIT_SHA="$(git rev-parse HEAD)"

echo "Building docker image for monorepo at $MONOREPO_ROOT"
echo "App version: $APP_VERSION"
echo "Git SHA: $GIT_SHA"

docker buildx build \
    -f "$SCRIPT_DIR/Dockerfile" \
    --platform linux/amd64,linux/arm64 \
    --progress=plain \
    -t "documenso/documenso:latest" \
    -t "documenso/documenso:$GIT_SHA" \
    -t "documenso/documenso:$APP_VERSION" \
    -t "ghcr.io/documenso/documenso:latest" \
    -t "ghcr.io/documenso/documenso:$GIT_SHA" \
    -t "ghcr.io/documenso/documenso:$APP_VERSION" \
    "$MONOREPO_ROOT"
