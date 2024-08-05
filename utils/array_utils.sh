
function _array_foreach() {
    local on_item="$1"
    shift
    local values=("$@")
    
    local index="0"
    local item
    for item in "${values[@]}"; do
        $on_item "$item" "$index"
        let "index = index + 1"
    done
}

function _array_where() {
    local predicate="$1"
    local -n result="$2"

    shift
    shift

    local values=("$@")

    local index="0"
    local item
    for item in "${values[@]}"; do
        if [[ "$($predicate "$item" "$index")" == true ]]; then
            result+=("$item")
        fi
        
        let "index = index + 1"
    done
}

function _array_map() {
    local on_item="$1"
    local -n result_array="$2"

    shift
    shift

    local values=("$@")
    
    local index="0"
    local item
    for item in "${values[@]}"; do
        result_array+=("$($on_item "$item" "$index")")
        let "index = index + 1"
    done
}

function _array_length() {
    local -n array="$1"

    echo "${#array[@]}"
}

function _array_equals() {
    local -n first="$1"
    local -n second="$2"

    [[ "${first[@]}" != "${second[@]}" ]] && echo false && return 0

    echo true
    return 0
}

function __array__demo() {
    local a=("aboba boba" boboba)
    echo "array foreach
    "

    _array_foreach echo "${a[@]}"

    echo "
    array map
    "

    (
        local result=()
        function _mapper() {
            echo "|item: $1, index: $2|"
        }

        _array_map _mapper result "${a[@]}"
        _array_foreach echo "${result[@]}"
    )

    echo "
    array where
    "

    (
        local res=()

        function _predicate() {
            [[ "$1" =~ aboba.* ]] && echo true && return 0

            echo false
            return 0
        }

        _array_where _predicate res "${a[@]}"
        _array_foreach echo "${res[@]}"
    )
}