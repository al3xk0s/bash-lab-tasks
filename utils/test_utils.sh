function _test_assert() {
    local expected="$1"
    local actual="$2"

    [[ "$expected" != "$actual" ]] && echo "Value \"$actual\" is not expected \"$expected\"" && return -1

    return 0
}

# Это поломано
function _test_case() {
    local name="$1"
    local executor="$2"

    [[ -z "$executor" ]] && executor="$name"

    $executor && return 0

    echo "Test \"$name\" is failure"
    return -1
}

