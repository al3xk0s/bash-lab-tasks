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

    [[ "$(__tte__validate_coordinates_point "$point")" != true ]] && \
    _get_player_step "$figure" "Введены неверные координаты. " && \
    return 0
    
    [[ "$(__tte__matrix_is_empty_point "$point")" != true ]] && \
    _get_player_step "$figure" "Выбранная точка занята. " && \
    return 0

    echo "$point"
    return 0
}

function _get_enemy_step() {    
    local variants=($(__tte__matrix_get_empty_points))

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
        [[ "$step" != '0' ]] && [[ "$(__tte__matrix_count_empty)" == '0' ]] && echo true && return 0

        echo false
        return 0
    }

    local step_value=""

    __tte__matrix_animated_clean

    while [ ! "$(_is_end_round)" = true ]; do
        clear
        __tte__matrix_print

        step_value="$(_get_step_value "$player_figure" "$enemy_figure" "$(_current_figure)")"
        __tte__matrix_set_figure_point "$step_value" "$(_current_figure)"
        step="$(( $step + 1 ))"        
    done
}


function main() {    
    _make_round 0 0 x o x
}


main "${@}"
