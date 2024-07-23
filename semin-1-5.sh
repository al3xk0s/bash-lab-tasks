#! /usr/bin/bash

source ./source_utils.sh

function _calculate_banknote() {
    local sum="$1"
    local banknotes=($2)

    local banknote
    local result
    
    for banknote in ${banknotes[@]}; do        
        result="$(_evaluate "$sum - $banknote")"

        if [ "$(_compare "$result >= 0")" = true ]; then
            echo "$banknote"
            return 0
        fi
    done

    return 0
}

function main() {    
    local sum="$1"
    local banknotes=(5000 2000 1000 500 200 100 50 10 5 1 0.5 0.1 0.05 0.01)
    local banknote

    [[ -z "$sum" ]] && echo "Positional argument [0] (change) expected" && return -1

    local validation_sum="0"

    while [ "$(_compare "$sum > 0")" = true ]; do
        banknote=""
        banknote="$(_calculate_banknote "$sum" "${banknotes[*]}")"
        
        if [[ -z "$banknote" ]]; then
            echo 'It is impossible to give change'
            return -1
        fi

        sum="$(_evaluate "$sum - $banknote")"
        
        echo "$banknote"
        validation_sum="$(_evaluate "$validation_sum + $banknote")"
    done

    echo
    echo '------'
    echo
    echo "$validation_sum"

    return 0
}


main "${@}"
