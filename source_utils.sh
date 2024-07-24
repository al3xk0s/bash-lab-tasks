function _get_random_str() {
    local defaultLength="8"

    local length="$1"
    local array=()

    [[ -z "$length" ]] && length="$defaultLength"

    for i in {a..z} {A..Z} {0..9}; do
        array[$RANDOM]=$i
    done

    printf %s ${array[@]::length}
}

function _get_random_hex() {
    local defaultLength="8"

    local length="$1"
    local array=()

    [[ -z "$length" ]] && length="$defaultLength"

    for i in {a..f} {0..9}; do
        array[$RANDOM]=$i
    done

    printf %s ${array[@]::length}
}

function _generate_random_id() {
    IFS=$'\n'

    local length="$1"
    local excludes=($2)

    local id="$(_get_random_hex "$length")"
    local exclude
    
    for exclude in ${excludes[@]}; do        
        if [[ "$exclude" == "$id" ]]; then
            _generate_random_id "$length" "${excludes[@]}"
            return 0
        fi
    done

    echo "$id"
    return 0
}

function _get_datetime() {
    date '+%d.%m.%Y %H:%M:%S'
}

function _get_nospace_datetime() {
    date '+%d.%m.%Y-%H:%M:%S'
}

function _evaluate() {
    local expression="$1"
    echo "$expression" | bc -l
}

function _compare() {
    local expression="$1"
    local result="$(_evaluate "$expression")"

    if [[ "$result" == 1 ]]; then
        echo true
        return 0
    fi

    echo false
    return 0
}


function _is_even() {
    local value="$1"

    local ceil_result
    let "ceil_result = $value / 2"    
    local result="$(_evaluate "$value / 2 - $ceil_result")"

    if [[ "$(_compare "$result > 0")" == true ]]; then
        echo false
        return 0
    fi

    echo true
    return 0
}
