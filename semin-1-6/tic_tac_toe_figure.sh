export __tte__cross='x'
export __tte__circle='o'
export __tte__cross_winner='X'
export __tte__circle_winner='@'
export __tte__empty='-'

export __tte__figure_pattern="[${__tte__cross}${__tte__circle}${__tte__cross_winner}${__tte__circle_winner}${__tte__empty}]"

function __tte__figure_validate() {
    local figure="$1"
    
    if [[ "$figure" =~ ($__tte__figure_pattern) ]]; then
        echo true && return 0
    fi

    echo false
    return 0
}

function __tte__figure_to_winner() {
    local figure="$1"

    [[ "$(__tte__figure_validate "$figure")" != true ]] && return -1
    
    [[ "$figure" == "$__tte__cross" ]] && echo "$__tte__cross_winner" && return 0
    [[ "$figure" == "$__tte__circle" ]] && echo "$__tte__circle_winner" && return 0

    echo "$figure"
    return 0
}

function __tte__figure_get_not_figure() {
    local figure="$1"

    [[ "$(__tte__figure_validate "$figure")" != true ]] && return -1

    ([[ "$figure" == "$__tte__cross" ]] || [[ "$figure" == "$__tte__cross_winner" ]]) && echo "$__tte__circle" && return 0
    ([[ "$figure" == "$__tte__circle" ]] || [[ "$figure" == "$__tte__circle_winner" ]]) && echo "$__tte__cross" && return 0

    echo "$__tte__empty"
    return 0
}
