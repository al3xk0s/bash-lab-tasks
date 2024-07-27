function __point__create() {
    local x="$1"
    local y="$2"

    echo "${x},${y}"
}

function __point__match() {
    local point="$1"

    if [[ "$point" =~ (^[0-9]+,[0-9]+$) ]]; then
        echo true
        return 0
    fi

    echo false
    return 0
}

function __point__get() {
    local point="$1"
    local coordinate="$2"

    [[ "$(__point__match "$point")" != true ]] && return -1
    [[ "$coordinate" != "x" ]] && [[ "$coordinate" != "y" ]] && return -1

    [[ "$coordinate" == "x" ]] && echo "${point/,*/}" && return 0

    echo "${point/*,/}"

    return 0
}

function __point__x() {
    __point__get "$1" x
}

function __point__y() {
    __point__get "$1" y
}

function __point__create_str_array() {
    local result=""
    local counter="0"

    local arg
    for arg in ${@}; do
        if [[ "$(_is_even "$counter")" == true  ]]; then
            result="${result}${arg}"
        else
            result="${result},${arg} "
        fi
        let "counter = counter + 1"
    done

    echo "$result"
}
