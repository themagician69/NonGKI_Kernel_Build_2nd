#!/usr/bin/env bash

set -x

# usage: curlx <url> <file name>
URL="$1"
OUTPUT="$2"

if [[ "$URL" == *"googlesource.com"* ]]; then
    # Google Source dynamic archives don't support range requests (-C -)
    curl --progress-bar -L "$URL" -o "$OUTPUT"
else
    curl -C - --progress-bar -L "$URL" -o "$OUTPUT"
fi
