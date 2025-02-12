#!/bin/bash

# Устанавливаем порог (например, 80% для RAM)
THRESHOLD=80

# Получаем текущую загрузку RAM в процентах
RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Если нагрузка на RAM больше порога, отправляем уведомление
if (( $(echo "$RAM_USAGE > $THRESHOLD" | bc -l) )); then
    # Параметры почты
    SUBJECT="Предупреждение: Загрузка RAM превышает порог"
    EMAIL="your_email@example.com"
    MESSAGE="Текущая загрузка RAM составляет ${RAM_USAGE}%."

    # Отправка письма
    echo "$MESSAGE" | mail -s "$SUBJECT" "$EMAIL"
fi

