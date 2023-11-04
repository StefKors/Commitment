#!/usr/bin/env bash
DIR="$(cd "$(dirname "$0")" && pwd)"
# OPTIONAL: Use jq to merge the two JSON files.

jq --slurp '.[1] as $logstat | .[0] | map(.paths = $logstat[.commit])' $DIR/git-log.json $DIR/git-stat.json