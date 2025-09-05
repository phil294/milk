#!/bin/bash
set -eo pipefail

source_file="milk.mmd"
trans_file="milk._trans.mmd"
build_file="milk._build.mmd"

# en###de. aicodedont@me
perl -0777 -pe '
	s/\["([^"\\]*?(?:\\.[^"\\]*?)*?)###([^"\\]*?(?:\\.[^"\\]*?)*?)"\]/["$1<br\/><span class=\"de_translation\">$2<\/span>"]/g;
	s/--\s*([^\-\n>]*?)###([^\-\n>]*?)\s*-->/-- $1<br\/><span class=\"de_translation\">$2<\/span> -->/g;
' "$source_file" > "$trans_file"

# {{{filename}}}
box_size=100
awk -v S="$box_size" 'function repl(fname){base="https://commons.wikimedia.org/wiki/Special:FilePath"; if(fname ~ /Cr%C3%A8me|Milk-bottle/) base="https://en.wikipedia.org/wiki/Special:FilePath"; return "<div class=\"wikimedia_box\"><img class=\"wikimedia_image\" src=\"" base "/" fname "?width=" S "\"\/><\/div><br>"} { while(match($0,/\{\{\{([^}]+)\}\}\}/,m)){ $0 = substr($0,1,RSTART-1) repl(m[1]) substr($0,RSTART+RLENGTH) } print }' "$trans_file" > "$build_file"

docker run --rm -u root -v "$PWD":/data minlag/mermaid-cli \
	-i /data/"$build_file" \
	-o /data/milk.mmd.svg \
	-b transparent \
	-c /data/mermaid_config.json \
	--cssFile /data/milk.css \
	--quiet

rm -f "$build_file" "$trans_file"
