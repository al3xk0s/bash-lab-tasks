source ./source_utils.sh
source ./point_structure.sh

export __tte__animation_delay='0.4'

export __tte__cross='x'
export __tte__circle='o'
export __tte__cross_winner='X'
export __tte__circle_winner='@'
export __tte__empty='-'

export __tte__figure_pattern="[${__tte__cross}${__tte__circle}${__tte__cross_winner}${__tte__circle_winner}${__tte__empty}]"

export __TIC_TAC_TOE_MATRIX=(
    "$__tte__empty" "$__tte__empty" "$__tte__empty"
    "$__tte__empty" "$__tte__empty" "$__tte__empty"
    "$__tte__empty" "$__tte__empty" "$__tte__empty"
)

export __tte__matrix_length=3

# 6 7 8   0 1 2 (2)
# 3 4 5   0 1 2 (1)
# 0 1 2   0 1 2 (0)

function __tte__validate_figure() {
    local figure="$1"
    
    if [[ "$figure" =~ ($__tte__figure_pattern) ]]; then
        echo true && return 0
    fi

    echo false
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

function __tte__validate_coordinates_point() {
    local point="$1"

    [[ "$(__point__match "$point")" != true ]] && return -1
    
    __tte__validate_coordinates "$(__point__x "$point")" "$(__point__y "$point")"
}

function __tte__matrix_map_coordinates() {
    local row="$1"
    local column="$2"   

    echo "$(( $row * $__tte__matrix_length + $column ))"
}

function __tte__matrix_set_figure() {
    local row="$1"
    local column="$2"    

    local figure="$3"
    
    [[ "$(__tte__validate_figure "$figure")" != true ]] && return -1
    [[ "$(__tte__validate_coordinates "$row" "$column")" != true ]] && return -1

    local index="$(__tte__matrix_map_coordinates "$row" "$column")"
    
    __TIC_TAC_TOE_MATRIX[$index]="$figure"    
    return 0
}

function __tte__matrix_set_figure_point() {
    local point="$1"
    local figure="$2"

    [[ "$(__point__match "$point")" != true ]] && return -1

    __tte__matrix_set_figure "$(__point__x "$point")" "$(__point__y "$point")" "$figure"
}

function __tte__matrix_get_figure() {
    local row="$1"
    local column="$2"    

    [[ "$(__tte__validate_coordinates "$row" "$column")" != true ]] && return -1

    local index="$(__tte__matrix_map_coordinates "$row" "$column")"
    
    echo "${__TIC_TAC_TOE_MATRIX[$index]}"
    return 0
}

function __tte__matrix_get_figure_point() {
    local point="$1"    

    [[ "$(__point__match "$point")" != true ]] && return -1

    __tte__matrix_get_figure "$(__point__x "$point")" "$(__point__y "$point")"
}

function __tte__matrix_fill() {
    local figure="$1"

    local r
    local c

    [[ "$(__tte__validate_figure "$figure")" != true ]] && return -1

    for ((r = 0 ; r < __tte__matrix_length ; r++)); do        
        for ((c = 0 ; c < __tte__matrix_length ; c++)); do
            __tte__matrix_set_figure "$r" "$c" "$figure"
        done
    done
}

function __tte__matrix_fill_points() {
    IFS=" "
    local figure="$1"
    local points=($2)


    local point
    for point in ${points[@]}; do
        __tte__matrix_set_figure_point "$point" "$figure"
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
            row="$row|$(__tte__matrix_get_figure "$r" "$c")"
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

    __tte__matrix_set_figure 2 0 "$__tte__circle"
    __tte__matrix_set_figure 0 2 "$__tte__cross"
    __tte__matrix_animation_frame

    __tte__matrix_set_figure 1 0 "$__tte__circle"
    __tte__matrix_set_figure 1 2 "$__tte__cross"
    __tte__matrix_animation_frame

    __tte__matrix_set_figure 0 0 "$__tte__circle"
    __tte__matrix_set_figure 2 2 "$__tte__cross"
    __tte__matrix_animation_frame

    __tte__matrix_set_figure 0 1 "$__tte__circle"
    __tte__matrix_set_figure 2 1 "$__tte__cross"
    __tte__matrix_animation_frame no-clean
    __tte__animation_delay 3
    clear
    __tte__matrix_clean
    __tte__matrix_animation_frame no-clean
}

function __tte__matrix_is_row_winner() {    
    local row="$1"
    local figure="$2"

    ([[ -z "$figure" ]] || [[ -z "$coordinate" ]]) && return -1

    [[ "$(__tte__matrix_get_figure "$coordinate" 0)" == "$figure" ]] && \
    [[ "$(__tte__matrix_get_figure "$coordinate" 1)" == "$figure" ]] && \
    [[ "$(__tte__matrix_get_figure "$coordinate" 2)" == "$figure" ]] && \
        echo true && return 0

    echo false
    return 0
}

function __tte__matrix_is_column_winner() {    
    local row="$1"
    local figure="$2"

    ([[ -z "$figure" ]] || [[ -z "$coordinate" ]]) && return -1

    [[ "$(__tte__matrix_get_figure 0 "$coordinate")" == "$figure" ]] && \
    [[ "$(__tte__matrix_get_figure 1 "$coordinate")" == "$figure" ]] && \
    [[ "$(__tte__matrix_get_figure 2 "$coordinate")" == "$figure" ]] && \
            echo true && return 0

    echo false
    return 0
}


function __tte__matrix_get_winner_points() {
    local figure="$1"

    [[ "$(__tte__validate_figure "$figure")" != true ]] && return -1

    [[ "$(__tte__matrix_get_figure 0 0)" == "$figure" ]] && \
    [[ "$(__tte__matrix_get_figure 1 1)" == "$figure" ]] && \
    [[ "$(__tte__matrix_get_figure 2 2)" == "$figure" ]] && \
        __point__create_str_array 0 0 1 1 2 2 && return 0

    [[ "$(__tte__matrix_get_figure 2 0)" == "$figure" ]] && \
    [[ "$(__tte__matrix_get_figure 1 1)" == "$figure" ]] && \
    [[ "$(__tte__matrix_get_figure 0 2)" == "$figure" ]] && \
        __point__create_str_array 2 0 1 1 0 2 && return 0

    [[ "$(__tte__matrix_is_row_winner 0 "$figure")" == true ]] && \
        __point__create_str_array 0 0 0 1 0 2 && return 0

    [[ "$(__tte__matrix_is_row_winner 1 "$figure")" == true ]] && \
        __point__create_str_array 1 0 1 1 1 2 && return 0

    [[ "$(__tte__matrix_is_row_winner 2 "$figure")" == true ]] && \
        __point__create_str_array 2 0 2 1 2 2 && return 0
    

    [[ "$(__tte__matrix_is_column_winner 0 "$figure")" == true ]] && \
        __point__create_str_array 0 0 1 0 2 0 && return 0

    [[ "$(__tte__matrix_is_column_winner 1 "$figure")" == true ]] && \
        __point__create_str_array 0 1 1 1 2 1 && return 0

    [[ "$(__tte__matrix_is_column_winner 2 "$figure")" == true ]] && \
        __point__create_str_array 0 2 1 2 2 2 && return 0

    echo ""
    return 0
}

function __tte__matrix_get_winner_coordinates_pair() {
    local cross_winner_points="$(__tte__matrix_get_winner_points "$__tte__cross")"
    local circle_winner_points="$(__tte__matrix_get_winner_points "$__tte__circle")"

    [[ "$cross_winner_points" != "" ]] && echo "${__tte__cross} ${cross_winner_points}" && return 0
    [[ "$circle_winner_points" != "" ]] && echo "${__tte__circle} ${circle_winner_points}" && return 0

    echo "$__tte__empty"
    return 0
}

function __tte__matrix_has_winner() {
    [[ "$(__tte__matrix_get_winner_coordinates_pair)" == "$__tte__empty" ]] && echo false && return 0

    echo true
    return 0
}

function __tte__matrix_get_coordinates_by_wc_pair() {
    local pair="$1"

    echo "${pair/$__tte__validate_figure? /}"
}

function __tte__matrix_count() {
    local figure="$1"

    [[ "$(__tte__validate_figure "$figure")" != true ]] && return -1

    local counter="0"

    local r
    local c
    for ((r = 0 ; r < __tte__matrix_length ; r++)); do
        for ((c = 0 ; c < __tte__matrix_length ; c++)); do
            if [[ "$(__tte__matrix_get_figure "$r" "$c")" == "$figure" ]]; then
                let "counter = counter + 1"
            fi
        done
    done

    echo "$counter"
}

function __tte__matrix_count_empty() {
    __tte__matrix_count "$__tte__empty"
}

function __tte__get_winner_figure() {
    local figure="$1"

    [[ "$(__tte__validate_figure "$figure")" != true ]] && return -1
    
    [[ "$figure" == "$__tte__cross" ]] && echo "$__tte__cross_winner" && return 0
    [[ "$figure" == "$__tte__circle" ]] && echo "$__tte__circle_winner" && return 0

    echo "$figure"
    return 0
}

function __tte__matrix_get_points() {
    local figure="$1"
    local result=""

    local r
    local c
    local point
    
    for ((r = 0 ; r < __tte__matrix_length ; r++)); do
      for ((c = 0 ; c < __tte__matrix_length ; c++)); do
        point="$(__point__create "$r" "$c")"
        if [[ "$(__tte__matrix_get_figure_point "$point")" == "$figure" ]]; then
            if [[ "$result" == "" ]]; then
                result="$point"
            else
                result="$result $point"
            fi            
        fi
      done  
    done

    echo "$result"
    return 0
}

function __tte__matrix_get_empty_points() {
    __tte__matrix_get_points "$__tte__empty"
}

function __tte__matrix_is_empty_point() {
    local point="$1"
    
    [[ "$(__point__match "$point")" != true ]] && return -1
    
    [[ "$(__tte__matrix_get_figure_point "$point")" == "$__tte__empty" ]] && echo true && return 0

    echo false
    return 0
}
