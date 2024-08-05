#! /usr/bin/bash

source ../utils/source_utils.sh

function _get_biggest_files() {
    IFS=$'\n'

    local biggest_size="$1"
    local biggest_files=($(find . -maxdepth 1 -type f -size "+${biggest_size}"))

    local item
    for item in "${biggest_files[@]}"; do
        echo "${item/.\//}"
    done
}

function _skip_file() {
    echo "File \"$1\" skiped"    
}

function _get_remove_file_text() {
    echo "File \"$1\" was removed at $(_get_datetime)"
}

function _remove_file() {
    rm "$1"
    _get_remove_file_text "$1"
}

function _compress_file() {
    local file="$1"
    local zipped_file_name="${file}.tar.gz"

    tar -cf "${zipped_file_name}" "${file}"
    echo "File \"$file\" has been compressed into file \"$zipped_file_name\""
    _remove_file "$file"
}

function _write_removed_files() {
    IFS=$'\n'
    local arr=($1)
    local target_file="removed-files-log-$(_get_nospace_datetime)"

    [[ -z "$1" ]] && return 0

    echo '' > "$target_file"

    local item
    for item in ${arr[@]}; do
        echo "$item" >> "$target_file"
    done

    return 0
}

function main() {
    IFS=$'\n'

    local biggest_size="$1"

    [[ -z "$biggest_size" ]] && biggest_size="100M"

    local biggest_files=($(_get_biggest_files "$biggest_size"))
    local removed_files=()

    local item

    for item in "${biggest_files[@]}"; do
        file_answer=""
        read -p "File $item over ${biggest_size} [remove | r or compress | c]: " file_answer


        if ([ "$file_answer" == 'compress' ] || [ "$file_answer" == 'c' ]); then
            _compress_file "$item"
            echo
            continue
        fi
        
        if ([ "$file_answer" == 'remove' ] || [ "$file_answer" == 'r' ]); then
            _remove_file "$item"
            removed_files+=("$(_get_remove_file_text "$item")")
            echo
            continue
        fi        

        _skip_file "$item"
        echo
    done

    _write_removed_files "${removed_files[@]}"
}

main "${@}"
