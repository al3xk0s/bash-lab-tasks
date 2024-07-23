#! /usr/bin/bash

source ./source_utils.sh

function main() {
    local original_file="$0"
    cp "$original_file" "./$(_get_random_str).sh"
}

main "${@}"
