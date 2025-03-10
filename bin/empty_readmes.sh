#!/usr/bin/env bash
# Find READMEs that are empty, because sometimes I forget to paste in the instructions.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/lib.sh
cd_git_root

git ls-files | grep README.txt | xargs -I {} sh -c 'wc -l {}' | grep "^\s*0\s" | awk '{print $2}'
