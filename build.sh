#!/bin/bash
set -eo pipefail

docker run --rm -u root -v "$PWD":/data minlag/mermaid-cli \
	-i milk.mmd \
	-b transparent \
	-c mermaid_config.json \
	--quiet
