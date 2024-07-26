#! /usr/bin/bash

source ./source_utils.sh
source ./tic_tac_toe_utils.sh
source ./point_structure.sh

function _get_player_step() {
    local figure="$1"
    local prefix="$2"

    read -p "${prefix}Введите строку и столбец через пробел (Вы $figure): " player_step

    local row="${player_step/ */}"
    local column="${player_step/* /}"

    local point="$(__point__create "$row" "$column")"

    [[ "$(__tte__field_validate_point "$point")" != true ]] && \
    _get_player_step "$figure" "Введены неверные координаты. " && \
    return 0
    
    [[ "$(__tte__field_is_empty_point "$point")" != true ]] && \
    _get_player_step "$figure" "Выбранная точка занята. " && \
    return 0

    echo "$point"
    return 0
}

function _get_enemy_step() {    
    local variants=($(__tte__field_find_empty_points))

    local length="${#variants[@]}"

    [[ "$length" == 0 ]] && return -1
    
    sleep "$(_random_short 2).$(_random_short_between 5 100)"
    echo "${variants[$(( $RANDOM % $length ))]}"

    return 0
}

function _get_step_value() {
    local player_figure="$1"
    local enemy_figure="$2"

    local current_figure="$3"

    [[ "$current_figure" == "$player_figure" ]] && _get_player_step "$player_figure" && return 0

    _get_enemy_step && return 0
}

function _on_round_end() {
    local player_score="$1"
    local enemy_score="$2"

    local player_figure="$3"
    local enemy_figure="$4"

    local winner_points_str="$(__tte__field_get_winner_points_pair)"

    local winner="$(__tte__field_get_winner)"
    local winner_points="$(__tte__field_get_winner_points)"

    [[ "$winner" == "$__tte_empty" ]] && _on_round_draw && return 0

    __tte__field_fill_points "$(__tte__figure_to_winner "$winner")" "$winner_points"
    clear    
    __tte__field_print
}

function _make_round() {
    local player_score="$1"
    local enemy_score="$2"

    local player_figure="$3"
    local enemy_figure="$4"

    local first_step_figure="$5"

    local players=("$first_step_figure")

    if [[ "$first_step_figure" == "$player_figure" ]]; then
        players+=("$enemy_figure")
    else
        players+=("$player_figure")
    fi
    
    local step="0"

    function _current_figure() {
        echo "${players[$(( $step % 2 ))]}"
    }

    function _is_end_round() {
        [[ "$step" != '0' ]] && ([[ "$(__tte__field_count_empty)" == '0' ]] || [[ "$(__tte__field_has_winner)" == true ]]) && echo true && return 0

        echo false
        return 0
    }

    local step_value=""

    __tte__field_animated_clean

    while [ ! "$(_is_end_round)" = true ]; do
        clear
        __tte__field_print

        step_value="$(_get_step_value "$player_figure" "$enemy_figure" "$(_current_figure)")"
        __tte__field_set "$step_value" "$(_current_figure)"
        step="$(( $step + 1 ))"        
    done

    _on_round_end \
        "$player_score" \
        "$enemy_score" \
        "$player_figure" \
        "$enemy_figure"
}


function main() {    
    _make_round 0 0 $__tte__cross $__tte__circle $__tte__cross
}


main "${@}"
