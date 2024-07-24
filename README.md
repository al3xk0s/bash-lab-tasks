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