#!/bin/bash

set -eo pipefail

cat milk.mmd \
	| sed -E 's/IMG:::(.+?):([0-9]+):([0-9]+)/<a href='"'"'https:\/\/commons.wikimedia.org\/wiki\/File:\1'"'"'><img src='"'"'https:\/\/commons.wikimedia.org\/wiki\/Special:FilePath\/\1?width=\2'"'"' width='"'"'\2'"'"' height='"'"'\3'"'"'><\/a>/g' \
	| sed -E 's/###(.+?)"/<br\/><span class=\"de\">\1<\/span>"/g' \
	> tmp.mmd

docker run --rm -u root -v "$PWD":/data minlag/mermaid-cli \
	-i /data/tmp.mmd \
	-o /data/milk.mmd.svg \
	-b transparent \
	-c /data/mermaid_config.json \
	--cssFile /data/milk.css \
	--quiet
rm tmp.mmd

sed -i -E 's/width: 100%;//g' milk.mmd.svg
