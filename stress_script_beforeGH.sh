#!/bin/bash

TYPE=""
THREADS="1"
VALUE="1000"
TIMEOUT="30"

# Показ помощи
help () {
    echo "Использование: $0 --type <cpu|ram> [--threads <N>] [--value <MB>] [--timeout <секунды>]"
    echo "Пример для CPU: $0 --type cpu --threads 4 --timeout 30  # Нагрузка на 4 потока CPU в течение 30 сек."
    echo "Пример для RAM: $0 --type ram --value 256 --timeout 30  # Нагрузка на 256MB RAM в течение 30 сек."
    exit 1
}

# Разбор аргументов через getopts
while [[ $# -gt 0 ]]; do
    case "$1" in
        --type)
            TYPE="$2"
            shift 2
            ;;
        --threads)
            THREADS="$2"
            shift 2
            ;;
        --value)
            VALUE="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        *)
            echo "Неизвестный параметр"
            help
            ;;
    esac
done

# Проверка аргументов
if [[ -z "$TYPE" ]]; then
    echo "Ошибка: Не указан тип нагрузки (--type cpu или ram)"
    help
fi

# Создание нагрузки на CPU
stress_cpu() {
    echo "Нагрузка CPU на $THREADS потоков. Завершится через $TIMEOUT секунд"
    for i in $(seq 1 "$THREADS"); do
        while :; do :; done &
    done
    sleep "$TIMEOUT" && kill $$ &
    wait
}

# Создание нагрузки на RAM
stress_ram() {
    echo "Нагрузка RAM на $VALUE MB (завершится через $TIMEOUT секунд)"
    BYTES=$((VALUE * 1024 * 1024))
    head -c "$BYTES" /dev/zero | tail >/dev/null &
    sleep "$TIMEOUT" && kill $$ &
    wait
}

# Завершение нагрузки
clean() {
    echo "Завершение нагрузки..."
    pkill -P $$ 
    exit 0
}

# Обработка сигланов завершения
trap clean SIGINT SIGTERM

# Запуск нужной нагрузки
case "$TYPE" in
    cpu)
        stress_cpu
        ;;
    ram)
        stress_ram
        ;;
    *)
        echo "Ошибка: Неверный тип нагрузки. Используйте --type cpu или --type ram"
        help
        ;;
esac

