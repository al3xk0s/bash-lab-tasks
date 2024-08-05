#! /usr/bin/bash

source ../../utils/source_utils.sh
source ./tic_tac_toe_utils.sh
source ./point_structure.sh

ENEMY_NAME="Megabot Gigachad"
SYSTEM_NAME="Мастер игры"
PLAYER_NAME="Игрок"

function _says() {
    local name="$1"

    echo "$name: "
}

function _system_say() {
    echo "$(_says "${SYSTEM_NAME}") $1"
}

function _enemy_say() {
    echo "$(_says "${ENEMY_NAME}") $1"
}

function _get_player_step() {
    local figure="$1"
    local prefix="$2"

    read -p "$(_says "$SYSTEM_NAME") ${prefix}Введите строку и столбец через пробел (Вы $figure): " player_step

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
    local winner_points_str="$(__tte__field_get_winner_points_pair)"

    local winner="$(__tte__field_get_winner)"
    [[ "$winner" == "$__tte_empty" ]] && return 0

    clear
    __tte__field_print_winner_points    
}

function _make_round() {
    local player_figure="$1"
    local enemy_figure="$2"

    local players=("$__tte__cross" "$__tte__circle")

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

    while [ ! "$(_is_end_round)" = true ]; do
        clear
        __tte__field_print

        step_value="$(_get_step_value "$player_figure" "$enemy_figure" "$(_current_figure)")"
        __tte__field_set "$step_value" "$(_current_figure)"
        step="$(( $step + 1 ))"               
    done

    _on_round_end
}

function _on_player_fail() {
    local phrases=(
        'Моя бабушка играет лучше, а она - тостер'
        'Как кожаный мешок может захватить власть, когда он не может поставить крестик или нолик'
        'Ха ха ха, 404. Интеллект вышел из чата'
        'Лучше бы я играл сам с собой'
        'Рекурсия - явно не твой конек'
        'Можешь погулять, пока я вычисляю число ПИ'
        'На твоем месте, я бы вышел из игры навсегда'
    )

    _enemy_say "$(_array_random_value phrases)"
}

function _game_delay() {
    local multiplier="$1"

    [[ -z "$multiplier" ]] && multiplier=1

    sleep "$(( 3 * $multiplier ))"
}

function _end_game() {
    local player_score="$1"
    local enemy_score="$2"

    "$(_compare "$player_score > $enemy_score")" && _system_say "${PLAYER_NAME} победил!"
    "$(_compare "$player_score < $enemy_score")" && _system_say "${ENEMY_NAME} победил!"
    "$(_compare "$player_score == $enemy_score")" && _system_say "Серия игр закончилась ничьей!!!"
    
    echo
    _system_say "Всем спасибо!"
}

function _is_continue() {
    local prefix="$1"
    local player_action

    read -p "$(_says "$SYSTEM_NAME") ${prefix}Продолжить [y/n]: " player_action

    [[ "$player_action" == "y" ]] && echo true && return 0
    [[ "$player_action" == "n" ]] && echo false && return 0

    _read_player_continue "Введен неизвестный ответ. "
    return 0
}

function _make_game() {
    local player_score="$1"
    local enemy_score="$2"

    local player_figure="$(__tte__get_random_figure)"
    local enemy_figure="$(__tte__figure_get_not_figure "$player_figure")"
    local current_winner
    local player_continue

    function _print_score() {
        _system_say "${PLAYER_NAME} - $player_score, ${ENEMY_NAME} - $enemy_score"
    }

    function _swap_figures() {
        player_figure="$enemy_figure"
        enemy_figure="$(__tte__figure_get_not_figure "$player_figure")"
    }

    while true; do
        __tte__field_animated_clean                
        _make_round "$player_figure" "$enemy_figure"
        current_winner="$(__tte__field_get_winner)"

        if [[ "$current_winner" == "$enemy_figure" ]]; then
            _on_player_fail
            let "enemy_score = $enemy_score + 1"
        elif [[ "$current_winner" == "$player_figure" ]]; then
            let "player_score = $player_score + 1"
        else
            _system_say "Ничья"
        fi

        echo
        _print_score

        [[ "$(_is_continue)" != true ]] && _end_game "$player_score" "$enemy_score" && return 0
        _swap_figures
    done

    return 0
}


function main() {    
    _make_game 0 0
}


main "${@}"
