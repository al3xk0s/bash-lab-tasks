source ./source_utils.sh

__tte__animation_delay='0.4'

__tte__cross='x'
__tte__circle='o'
__tte__cross_winner='X'
__tte__circle_winner='O'
__tte__empty='-'

__TIC_TAC_TOE_MATRIX=(
    "$__tte__empty" "$__tte__empty" "$__tte__empty"
    "$__tte__empty" "$__tte__empty" "$__tte__empty"
    "$__tte__empty" "$__tte__empty" "$__tte__empty"
)

__tte__matrix_length=3

# 6 7 8   0 1 2 (2)
# 3 4 5   0 1 2 (1)
# 0 1 2   0 1 2 (0)

function __tte__validate_value() {
    local value="$1"

    [[ "$value" != "$__tte__cross" ]] && \
    [[ "$value" != "$__tte__circle" ]] && \
    [[ "$value" != "$__tte__cross_winner" ]] && \
    [[ "$value" != "$__tte__circle_winner" ]] && \
    [[ "$value" != "$__tte__empty" ]] && \
        echo false && return 0

    echo true
    return 0
}

function __tte__validate_coordinates() {
    local row="$1"
    local column="$2"

    ([[ -z "$row" ]] || [[ -z "$column" ]]) && echo false && return 0     

    [ "$row" -ge "0" ] && [ "$row" -lt "3" ] && \
    [ "$column" -ge "0" ] && [ "$column" -lt "3" ] && \
        echo true && return 0

    echo false
    return 0
}

function __tte__matrix_set_value() {
    local row="$1"
    local column="$2"    

    local value="$3"

    [[ "$(__tte__validate_value "$value")" != true ]] && return -1
    [[ "$(__tte__validate_coordinates "$row" "$column")" != true ]] && return -1

    local index="$(_evaluate "$row * 3 + $column")"
    
    __TIC_TAC_TOE_MATRIX[$index]="$value"    
    return 0
}

function __tte__matrix_get_value() {
    local row="$1"
    local column="$2"    

    [[ "$(__tte__validate_coordinates "$row" "$column")" != true ]] && return -1

    local index="$(_evaluate "$row * 3 + $column")"
    
    echo "${__TIC_TAC_TOE_MATRIX[$index]}"
    return 0
}

function __tte__matrix_fill() {
    local value="$1"

    local r
    local c

    [[ "$(__tte__validate_value "$value")" != true ]] && return -1

    for ((r = 0 ; r < __tte__matrix_length ; r++)); do        
        for ((c = 0 ; c < __tte__matrix_length ; c++)); do
            __tte__matrix_set_value "$r" "$c" "$value"
        done
    done
}

function __tte__matrix_clean() {
    __tte__matrix_fill "$__tte__empty"
}

function __tte__matrix_print() {
    local r
    local c    
    local row=""

    for ((r = __tte__matrix_length - 1 ; r >= 0; r--)); do
        row="$r "
        for ((c = 0 ; c < __tte__matrix_length ; c++)); do
            row="$row|$(__tte__matrix_get_value "$r" "$c")"
        done
        row="$row|"
        echo "$row"        
    done
    echo "   0 1 2"
}

function __tte__animation_delay() {
    local delay="$__tte__animation_delay"
    local count="$1"

    [[ -z "$count" ]] && count="1"

    local i
    for ((i = 0 ; i < count ; i++)); do
        sleep "$delay"    
    done    
}

function __tte__matrix_animation_frame() {
    local clean="$1"

    [[ -z "$clean" ]] && clean=true

    __tte__matrix_print
    __tte__animation_delay
    [[ "$clean" == true ]] && clear
}

function __tte__matrix_animated_clean() {
    local delay="$1"

    [[ -z "$delay" ]] && delay="0.5"

    clear
    __tte__matrix_fill "$__tte__cross"    
    __tte__matrix_animation_frame
    __tte__matrix_fill "$__tte__circle"
    __tte__matrix_animation_frame
    __tte__matrix_fill "$__tte__empty"
    __tte__matrix_animation_frame

    __tte__matrix_set_value 2 0 "$__tte__circle"
    __tte__matrix_set_value 0 2 "$__tte__cross"
    __tte__matrix_animation_frame

    __tte__matrix_set_value 1 0 "$__tte__circle"
    __tte__matrix_set_value 1 2 "$__tte__cross"
    __tte__matrix_animation_frame

    __tte__matrix_set_value 0 0 "$__tte__circle"
    __tte__matrix_set_value 2 2 "$__tte__cross"
    __tte__matrix_animation_frame

    __tte__matrix_set_value 0 1 "$__tte__circle"
    __tte__matrix_set_value 2 1 "$__tte__cross"
    __tte__matrix_animation_frame no-clean
    __tte__animation_delay 3
    clear
    __tte__matrix_clean
    __tte__matrix_animation_frame no-clean
}

function __tte__matrix_is_line_winner() {
    local type="$1"
    local coordinate="$2"
    local value="$3"

    (\
        [[ -z "$value" ]] || \
        [[ -z "$coordinate" ]] || \
        ([[ "$type" != "row" ]] && [[ "$type" != "column" ]])\
    ) && return -1

    if [[ "$type" == "row" ]]; then
        [[ "$(__tte__matrix_get_value "$coordinate" 0)" == "$value" ]] && \
        [[ "$(__tte__matrix_get_value "$coordinate" 1)" == "$value" ]] && \
        [[ "$(__tte__matrix_get_value "$coordinate" 2)" == "$value" ]] && \
            echo true && return 0

        echo false
        return 0
    fi

    [[ "$(__tte__matrix_get_value 0 "$coordinate")" == "$value" ]] && \
    [[ "$(__tte__matrix_get_value 1 "$coordinate")" == "$value" ]] && \
    [[ "$(__tte__matrix_get_value 2 "$coordinate")" == "$value" ]] && \
            echo true && return 0

    echo false
    return 0
}

function __tte__matrix_is_winner() {
    local value="$1"

    [[ "$(__tte__validate_value "$value")" != true ]] && return -1

    [[ "$(__tte__matrix_get_value 0 0)" == "$value" ]] && \
    [[ "$(__tte__matrix_get_value 1 1)" == "$value" ]] && \
    [[ "$(__tte__matrix_get_value 2 2)" == "$value" ]] && \
        echo true && return 0

    [[ "$(__tte__matrix_get_value 2 0)" == "$value" ]] && \
    [[ "$(__tte__matrix_get_value 1 1)" == "$value" ]] && \
    [[ "$(__tte__matrix_get_value 0 2)" == "$value" ]] && \
        echo true && return 0

    (\
        [[ "$(__tte__matrix_is_line_winner row 0 "$value")" == true ]] || \
        [[ "$(__tte__matrix_is_line_winner row 1 "$value")" == true ]] || \
        [[ "$(__tte__matrix_is_line_winner row 2 "$value")" == true ]] || \
        [[ "$(__tte__matrix_is_line_winner column 0 "$value")" == true ]] || \
        [[ "$(__tte__matrix_is_line_winner column 1 "$value")" == true ]] || \
        [[ "$(__tte__matrix_is_line_winner column 2 "$value")" == true ]] \
    ) && echo true && return 0

    echo false
    return 0
}

function __tte__matrix_get_winner() {
    local cross_winner="$(__tte__matrix_is_winner "$__tte__cross")"
    local circle_winner="$(__tte__matrix_is_winner "$__tte__circle")"

    [[ "$cross_winner" == true ]] && echo "$__tte__cross" && return 0
    [[ "$circle_winner" == true ]] && echo "$__tte__circle" && return 0

    echo "$__tte__empty"
    return 0
}

function __tte__matrix_count() {
    local value="$1"

    [[ "$(__tte__validate_value "$value")" != true ]] && return -1

    local counter="0"

    local r
    local c
    for ((r = 0 ; r < __tte__matrix_length ; r++)); do
        for ((c = 0 ; c < __tte__matrix_length ; c++)); do
            if [[ "$(__tte__matrix_get_value "$r" "$c")" == "$value" ]]; then
                let "counter = counter + 1"
            fi
        done
    done

    echo "$counter"
}
