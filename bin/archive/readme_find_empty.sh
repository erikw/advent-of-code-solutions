#!/usr/bin/env bash
# Find READMEs that are empty, because sometimes I forget to paste in the instructions.

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TARGET=README.md

# shellcheck source=bin/aoc_lib.sh
. "$SCRIPT_DIR/aoc_lib.sh"
aoc_init_script

git ls-files | grep "$TARGET" | xargs -I {} sh -c 'wc -l {}' | grep "^\s*0\s" | awk '{print $2}'
