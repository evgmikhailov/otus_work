#!/bin/bash
set -x
# Директория для резервных копий
DIR="/mnt/nfs/bkp/mysql/ubuntu06/backup"

# Команда для подключения к MySQL
MYSQL="mysql --skip-column-names"

# Создание директории для резервных копий, если её нет
mkdir -p "$DIR"

# Получение списка баз данных (исключая системные базы)
DATABASES=$($MYSQL -e "SHOW DATABASES" | grep -Ev '(Database|information_schema|performance_schema|mysql|sys)')

# Резервное копирование каждой базы данных
for DB in $DATABASES; do
    # Создание директории для базы данных
    mkdir -p "$DIR/$DB"

    # Получение списка таблиц в базе данных
    TABLES=$($MYSQL -e "SHOW TABLES FROM $DB")

    # Резервное копирование каждой таблицы
    for TABLE in $TABLES; do
        echo "Backing up $DB.$TABLE..."
        mysqldump \
            --add-drop-table \
            --add-locks \
            --create-options \
            --disable-keys \
            --extended-insert \
            --set-gtid-purged=ON \
            --single-transaction \
            "$DB" "$TABLE" > "$DIR/$DB/$TABLE.sql"
    done
done

echo "Backup completed!"




