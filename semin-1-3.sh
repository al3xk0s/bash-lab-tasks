#! /usr/bin/bash

source ./source_utils.sh

function main() {
    local excludes_file="id.rng"

    [[ ! -f "$excludes_file" ]] && > "$excludes_file"
    
    local excludes_ids="$(cat "$excludes_file")"
    local valid_id="$(_generate_random_id 6 "$excludes_ids")"

    echo "$valid_id" >> "$excludes_file"
    echo "$valid_id"
}

main "${@}"
