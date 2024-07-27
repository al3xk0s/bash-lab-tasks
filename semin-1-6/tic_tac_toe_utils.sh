source ../source_utils.sh
source ./point_structure.sh
source ./tic_tac_toe_field.sh

export __tte__animation_delay='0.4'

# 6 7 8   0 1 2 (2)
# 3 4 5   0 1 2 (1)
# 0 1 2   0 1 2 (0)

function __tte__field_print() {
    local r
    local c    
    local row=""

    for ((r = __tte__field_length - 1 ; r >= 0; r--)); do
        row="$r "
        for ((c = 0 ; c < __tte__field_length ; c++)); do
            row="$row|$(__tte__field_get "$r" "$c")"
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

function __tte__field_animation_frame() {
    local clean="$1"

    [[ -z "$clean" ]] && clean=true

    __tte__field_print
    __tte__animation_delay
    [[ "$clean" == true ]] && clear
}

function __tte__field_animated_clean() {
    local delay="$1"

    [[ -z "$delay" ]] && delay="0.5"

    clear
    __tte__field_fill_all "$__tte__cross"    
    __tte__field_animation_frame
    __tte__field_fill_all "$__tte__circle"
    __tte__field_animation_frame
    __tte__field_fill_all "$__tte__empty"
    __tte__field_animation_frame

    __tte__field_set 2 0 "$__tte__circle"
    __tte__field_set 0 2 "$__tte__cross"
    __tte__field_animation_frame

    __tte__field_set 1 0 "$__tte__circle"
    __tte__field_set 1 2 "$__tte__cross"
    __tte__field_animation_frame

    __tte__field_set 0 0 "$__tte__circle"
    __tte__field_set 2 2 "$__tte__cross"
    __tte__field_animation_frame

    __tte__field_set 0 1 "$__tte__circle"
    __tte__field_set 2 1 "$__tte__cross"
    __tte__field_animation_frame no-clean
    __tte__animation_delay 3
    clear
    __tte__field_clean
    __tte__field_animation_frame no-clean
}

function __tte__field_is_row_winner() {    
    local row="$1"
    local figure="$2"

    ([[ -z "$figure" ]] || [[ -z "$row" ]]) && return -1

    [[ "$(__tte__field_get "$row" 0)" == "$figure" ]] && \
    [[ "$(__tte__field_get "$row" 1)" == "$figure" ]] && \
    [[ "$(__tte__field_get "$row" 2)" == "$figure" ]] && \
        echo true && return 0

    echo false
    return 0
}

function __tte__field_is_column_winner() {    
    local column="$1"
    local figure="$2"

    ([[ -z "$figure" ]] || [[ -z "$column" ]]) && return -1

    [[ "$(__tte__field_get 0 "$column")" == "$figure" ]] && \
    [[ "$(__tte__field_get 1 "$column")" == "$figure" ]] && \
    [[ "$(__tte__field_get 2 "$column")" == "$figure" ]] && \
            echo true && return 0

    echo false
    return 0
}


function __tte__field_find_winner_points() {
    local figure="$1"

    [[ "$(__tte__figure_validate "$figure")" != true ]] && return -1

    [[ "$(__tte__field_get 0 0)" == "$figure" ]] && \
    [[ "$(__tte__field_get 1 1)" == "$figure" ]] && \
    [[ "$(__tte__field_get 2 2)" == "$figure" ]] && \
        __point__create_str_array 0 0 1 1 2 2 && return 0

    [[ "$(__tte__field_get 2 0)" == "$figure" ]] && \
    [[ "$(__tte__field_get 1 1)" == "$figure" ]] && \
    [[ "$(__tte__field_get 0 2)" == "$figure" ]] && \
        __point__create_str_array 2 0 1 1 0 2 && return 0

    [[ "$(__tte__field_is_row_winner 0 "$figure")" == true ]] && \
        __point__create_str_array 0 0 0 1 0 2 && return 0

    [[ "$(__tte__field_is_row_winner 1 "$figure")" == true ]] && \
        __point__create_str_array 1 0 1 1 1 2 && return 0

    [[ "$(__tte__field_is_row_winner 2 "$figure")" == true ]] && \
        __point__create_str_array 2 0 2 1 2 2 && return 0
    

    [[ "$(__tte__field_is_column_winner 0 "$figure")" == true ]] && \
        __point__create_str_array 0 0 1 0 2 0 && return 0

    [[ "$(__tte__field_is_column_winner 1 "$figure")" == true ]] && \
        __point__create_str_array 0 1 1 1 2 1 && return 0

    [[ "$(__tte__field_is_column_winner 2 "$figure")" == true ]] && \
        __point__create_str_array 0 2 1 2 2 2 && return 0

    echo ""
    return 0
}

function __tte__field_get_winner_points_pair() {
    local cross_winner_points="$(__tte__field_find_winner_points "$__tte__cross")"
    local circle_winner_points="$(__tte__field_find_winner_points "$__tte__circle")"

    [[ "$cross_winner_points" != "" ]] && echo "${__tte__cross} ${cross_winner_points}" && return 0
    [[ "$circle_winner_points" != "" ]] && echo "${__tte__circle} ${circle_winner_points}" && return 0

    echo "$__tte__empty"
    return 0
}

function __tte__field_has_winner() {
    [[ "$(__tte__field_get_winner)" == "$__tte__empty" ]] && echo false && return 0

    echo true
    return 0
}

function __tte__field_get_winner() {
    local pair="$(__tte__field_get_winner_points_pair)"
    echo "${pair::1}"
}

function __tte__field_get_winner_points() {
    local pair="$(__tte__field_get_winner_points_pair)"
    echo "${pair/$__tte__figure_validate? /}"
}

function __tte__field_find_empty_points() {
    __tte__field_find_figure_points "$__tte__empty"
}

function __tte__field_is_empty_point() {
    local point="$1"
    
    [[ "$(__point__match "$point")" != true ]] && return -1
    
    [[ "$(__tte__field_get "$point")" == "$__tte__empty" ]] && echo true && return 0

    echo false
    return 0
}

function __tte__get_random_figure() {
    "$(_is_even "$RANDOM")" && echo "$__tte__cross" && return 0

    echo "$__tte__circle"
    return 0
}


function __tte__field_print_winner_points() {
    local winner="$(__tte__field_get_winner)"
    [[ "$winner" == "$__tte__empty" ]] && return 0

    local points="$(__tte__field_get_winner_points)"
    local savedArray=(${__TIC_TAC_TOE_FIELD[@]})
    
    __tte__field_fill_points "$(__tte__figure_to_winner "$winner")" "$points"
    __tte__field_print

    __TIC_TAC_TOE_FIELD=(${savedArray[@]})
}

function __tte__winner_column_test() {
    local expected="$1"

    __tte__field_clean && \
    __tte__field_fill_points "$expected" "0,0 1,0 2,0" && \
    _test_assert "$expected" "$(__tte__field_get_winner)" && \

    __tte__field_clean && \
    __tte__field_fill_points "$expected" "0,1 1,1 2,1" && \
    _test_assert "$expected" "$(__tte__field_get_winner)" && \

    __tte__field_clean && \
    __tte__field_fill_points "$expected" "0,2 1,2 2,2" && \
    _test_assert "$expected" "$(__tte__field_get_winner)" && \
    return 0

    return 1
}

function __tte__winner_row_test() {
    local expected="$1"

    __tte__field_clean && \
    __tte__field_fill_points "$expected" "0,0 0,1 0,2" && \
    _test_assert "$expected" "$(__tte__field_get_winner)" && \

    __tte__field_clean && \
    __tte__field_fill_points "$expected" "1,0 1,1 1,2" && \
    _test_assert "$expected" "$(__tte__field_get_winner)" && \

    __tte__field_clean && \
    __tte__field_fill_points "$expected" "2,0 2,1 2,2" && \
    _test_assert "$expected" "$(__tte__field_get_winner)" && \
    return 0

    return 1
}

function __tte__winner_diagonal_test() {
    local expected="$1"

    __tte__field_clean && \
    __tte__field_fill_points "$expected" "0,0 1,1 2,2" && \
    _test_assert "$expected" "$(__tte__field_get_winner)" && \

    __tte__field_clean && \
    __tte__field_fill_points "$expected" "2,0 1,1 0,2" && \
    _test_assert "$expected" "$(__tte__field_get_winner)" && \
    return 0

    return 1
}

function __tte__run_tests() {
    _test_case "__tte__winner_row_test $__tte__cross"
    _test_case "__tte__winner_column_test $__tte__cross"
    _test_case "__tte__winner_diagonal_test $__tte__cross"

    _test_case "__tte__winner_row_test $__tte__circle"
    _test_case "__tte__winner_column_test $__tte__circle"
    _test_case "__tte__winner_diagonal_test $__tte__circle"
}
