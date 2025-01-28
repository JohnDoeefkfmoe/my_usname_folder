#!/bin/bash

TYPE=$1  # Что нагружем: cpu или ram
VALUE=$2 # Количесство потоков или памяти в MB

# тут аргументы принимаются
if [[ -z "$TYPE" || -z "$VALUE" ]]; then
    echo "Введите: $0 <cpu|ram> <значение>"
    echo "Пример: $0 cpu 4  # Нагрузка на 4 потока"
    echo "Пример: $0 ram 256  # Нагрузка на 256 MB"
    exit 1
fi
# создание нагрузки на cpu
stress_cpu() {
    echo "Нагрузка CPU на $VALUE потоков"
    for i in $(seq 1 "$VALUE"); do
        while :; do :; done &
    done
    echo "Нагрузка пошла. Ctrl+C для остановки."
    wait
}
# создание нагрузки на ram
stress_ram() {
    echo "Нагрузка RAM на $VALUE MB"
    # Перевод значения из МБ в Б
    BYTES=$((VALUE * 1024 * 1024))
    head -c "$BYTES" /dev/zero | tail >/dev/null &
    echo "Нагрузка пошла. Ctrl+C для остановки."
    wait
}
# остановка процессов
clean() {
    echo "Завершение нагрузки"
    killall bash &>/dev/null
    exit 0
}

# сигланы завершения
trap clean SIGINT SIGTERM

# Выбор типа нагрузки
case "$TYPE" in
    cpu)
        stress_cpu
        ;;
    ram)
        stress_ram
        ;;
esac

#test
