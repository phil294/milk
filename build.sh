#!/bin/bash

set -eo pipefail

cat milk.mmd \
	| perl -pe 's/WIKI:::(.+?):(.+?)(?=["#<\/,])/<a href='"'"'https:\/\/en.wikipedia.org\/wiki\/\1'"'"'>\2<\/a>/g' \
	| perl -pe 's/WIKI:::(.+?)(?=["#<\/])/<a href='"'"'https:\/\/en.wikipedia.org\/wiki\/\1'"'"'>\1<\/a>/g' \
	| sed -E 's/IMG:::(.+?):([0-9]+):([0-9]+)/<a href='"'"'https:\/\/commons.wikimedia.org\/wiki\/File:\1'"'"'><img src='"'"'https:\/\/commons.wikimedia.org\/wiki\/Special:FilePath\/\1?width=\2'"'"' width='"'"'\2'"'"' height='"'"'\3'"'"'><\/a>/g' \
	| sed -E 's/###(.+?)("|-->)/<br\/><span class=\"de\">\1<\/span>\2/g' \
	> tmp.mmd

docker run --rm -u root -v "$PWD":/data minlag/mermaid-cli:11.9.1-beta.3 \
	-i /data/tmp.mmd \
	-o /data/milk.mmd.svg \
	-b transparent \
	-c /data/mermaid_config.json \
	--cssFile /data/milk.css \
	--quiet
rm tmp.mmd

sed -i -E 's/width: 100%;//g' milk.mmd.svg
