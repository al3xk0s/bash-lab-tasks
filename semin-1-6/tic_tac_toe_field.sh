source ./tic_tac_toe_figure.sh

export __TIC_TAC_TOE_FIELD=(
    "$__tte__empty" "$__tte__empty" "$__tte__empty"
    "$__tte__empty" "$__tte__empty" "$__tte__empty"
    "$__tte__empty" "$__tte__empty" "$__tte__empty"
)

export __tte__field_length=3

function __tte__field_validate_coordinates() {
    local row="$1"
    local column="$2"

    ([[ -z "$row" ]] || [[ -z "$column" ]]) && echo false && return 0     

    [ "$row" -ge "0" ] && [ "$row" -lt "3" ] && \
    [ "$column" -ge "0" ] && [ "$column" -lt "3" ] && \
        echo true && return 0

    echo false
    return 0
}

function __tte__field_validate_point() {
    local point="$1"

    [[ "$(__point__match "$point")" != true ]] && return -1
    
    __tte__field_validate_coordinates "$(__point__x "$point")" "$(__point__y "$point")"
}

function __tte__field_map_coordinates() {
    local row="$1"
    local column="$2"   

    echo "$(( $row * $__tte__field_length + $column ))"
}

function __tte__field_set() {
    local row_or_point="$1"
    local column_or_figure="$2"
    local figure="$3"

    "$(__point__match "$row_or_point")" && \
    __tte__field_set_figure_at_point "$row_or_point" "$column_or_figure" && \
    return 0

    __tte__field_set_figure_at_coordinates "$row_or_point" "$column_or_figure" "$figure"
    return 0
}

function __tte__field_set_figure_at_coordinates() {
    local row="$1"
    local column="$2"    

    local figure="$3"
    
    [[ "$(__tte__figure_validate "$figure")" != true ]] && return -1
    [[ "$(__tte__field_validate_coordinates "$row" "$column")" != true ]] && return -1

    local index="$(__tte__field_map_coordinates "$row" "$column")"
    
    __TIC_TAC_TOE_FIELD[$index]="$figure"    
    return 0
}

function __tte__field_set_figure_at_point() {
    local point="$1"
    local figure="$2"

    [[ "$(__point__match "$point")" != true ]] && return -1

    __tte__field_set "$(__point__x "$point")" "$(__point__y "$point")" "$figure"
}

function __tte__field_get() {
    local row_or_point="$1"
    local column="$2"

    "$(__point__match "$row_or_point")" && \
    __tte__field_get_figure_at_point "$row_or_point" && \
    return 0

    __tte__field_get_figure_at_coordinates "$row_or_point" "$column"
    return 0
}

function __tte__field_get_figure_at_coordinates() {
    local row="$1"
    local column="$2"

    [[ "$(__tte__field_validate_coordinates "$row" "$column")" != true ]] && return -1

    local index="$(__tte__field_map_coordinates "$row" "$column")"
    
    echo "${__TIC_TAC_TOE_FIELD[$index]}"
    return 0
}

function __tte__field_get_figure_at_point() {
    local point="$1"    

    [[ "$(__point__match "$point")" != true ]] && return -1

    __tte__field_get_figure_at_coordinates "$(__point__x "$point")" "$(__point__y "$point")"
}


function __tte__field_fill_all() {
    local figure="$1"

    local r
    local c

    [[ "$(__tte__figure_validate "$figure")" != true ]] && return -1

    for ((r = 0 ; r < __tte__field_length ; r++)); do        
        for ((c = 0 ; c < __tte__field_length ; c++)); do
            __tte__field_set "$r" "$c" "$figure"
        done
    done
}

function __tte__field_fill_points() {
    IFS=" "
    local figure="$1"
    local points=($2)


    local point
    for point in ${points[@]}; do
        __tte__field_set "$point" "$figure"
    done
}

function __tte__field_clean() {
    __tte__field_fill_all "$__tte__empty"
}

function __tte__field_count() {
    local figure="$1"

    [[ "$(__tte__figure_validate "$figure")" != true ]] && return -1

    local counter="0"

    local r
    local c
    for ((r = 0 ; r < __tte__field_length ; r++)); do
        for ((c = 0 ; c < __tte__field_length ; c++)); do
            if [[ "$(__tte__field_get "$r" "$c")" == "$figure" ]]; then
                let "counter = counter + 1"
            fi
        done
    done

    echo "$counter"
}

function __tte__field_count_empty() {
    __tte__field_count "$__tte__empty"
}

function __tte__field_find_figure_points() {
    local figure="$1"
    local result=""

    local r
    local c
    local point
    
    for ((r = 0 ; r < __tte__field_length ; r++)); do
      for ((c = 0 ; c < __tte__field_length ; c++)); do
        point="$(__point__create "$r" "$c")"
        if [[ "$(__tte__field_get "$point")" == "$figure" ]]; then
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
