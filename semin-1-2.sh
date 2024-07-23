#! /usr/bin/bash

function main() {
    local original_file="$0"
    cat "$original_file" | rev
}

main "${@}"
