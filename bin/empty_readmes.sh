#!/usr/bin/env bash
# Find READMEs that are empty, because sometimes I forget to paste in the instructions.
# TODO archive this once solve_day.sh automatically creates the README...

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TARGET=README.md

# shellcheck source=aoc_lib.sh
. "$SCRIPT_DIR/aoc_lib.sh"
cd_git_root

git ls-files | grep "$TARGET" | xargs -I {} sh -c 'wc -l {}' | grep "^\s*0\s" | awk '{print $2}'
