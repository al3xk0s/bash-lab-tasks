# Зависимости

sed
bc

# Занимательные заметки о bash

## Массивы

### Создать

```bash
arr=(1 2 '34')
```

### Массив как аргумент

**Передача массивом**

```bash
function _foo() {
  local some="$1"
  shift
  local_arr=("$@")
}

function main() {
  local arr=(1 2 3)
  _foo "${arr[@]}"
}
```

**Передача как строка**

```bash
function _foo() {
  IFS=" " # Можно установить разделитель

  local some="$1"
  shift
  local_arr=($2)
}

function main() {
  local arr=(1 2 3)
  _foo "${arr[*]}"
}
```

## Параметры

Полезная дока

https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

## Булеан значения

Вопреки всему, мы можем использовать булы

Например, есть функция:

```bash
function _is_even() {
    local value="$1"

    local result="$(( $value % 2 ))"

    [[ "$result" == '0' ]] && echo true && return 0

    echo false
    return 0
}
```

Её можно использовать как:

```bash
[[ "$(_is_even 2)" == true ]] && echo is_true
```

Так и:

```bash
"$(_is_even 2)" && echo is_true
```

**Но не так:**

```bash
[[ "$(_is_even 2)" ]] && echo is_true
```

## Строки

### Замена подстроки

```bash
MYVAR=ho02123ware38384you443d34o3434ingtod38384day
echo "$MYVAR" | sed -e 's/[a-zA-Z]/X/g' -e 's/[0-9]/N/g'
# prints XXNNNNNXXXXNNNNNXXXNNNXNNXNNNNXXXXXXNNNNNXXX
```

#### С помощью ванили

```bash
#First match:
$ a='I am a string'
$ echo "${a/a/A}"
I Am a string

# All matches:

$ echo "${a//a/A}"
I Am A string

#Match at the beginning:

$ echo "${a/#I/y}"
y am a string

#Match at the end:

$ echo "${a/%g/N}"
I am a strinN

#Replace a pattern with nothing:

$ echo "${a/g/}"
I am a strin

#Add prefix to array items:

$ A=(hello world)
$ echo "${A[@]/#/R}"
Rhello Rworld
```
