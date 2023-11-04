#!/usr/bin/env bash
# source: https://gist.github.com/textarcana/1306223
DIR="$(cd "$(dirname "$0")" && pwd)"

$DIR/git-log2json.sh >> $DIR/git-log.json
$DIR/git-stat2json.sh >> $DIR/git-stat.json
$DIR/merge.sh >> $DIR/git-combined.json

rm $DIR/git-log.json
rm $DIR/git-stat.json
mv $DIR/git-combined.json ./
