#!/usr/bin/env bash
#
# run.sh — Собрать и запустить контейнер локально
#
# После запуска:
#   Портал: http://localhost:8080  (пароль из .env)
#
# Остановка:  docker compose down
# С удалением данных:  docker compose down -v

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Проверка ==="
echo "  course/  — $(find "$SCRIPT_DIR/course" -type f | wc -l | tr -d ' ') файлов"
echo "  skills/  — $(find "$SCRIPT_DIR/skills" -type d -maxdepth 1 | tail -n +2 | wc -l | tr -d ' ') навыков"

echo ""
echo "=== Сборка Docker-образа ==="
docker compose -f "$SCRIPT_DIR/docker-compose.yml" build

echo ""
echo "=== Запуск ==="
docker compose -f "$SCRIPT_DIR/docker-compose.yml" up -d

echo ""
echo "=== Готово! ==="
echo ""
echo "  Портал:       http://localhost:8080  (пароль из .env)"
echo "  Пароль:       $(grep '^PASSWORD=' "$SCRIPT_DIR/.env" 2>/dev/null | cut -d= -f2 || echo 'test123')"
echo ""
echo "  Остановка:            docker compose down"
echo "  Остановка + удаление: docker compose down -v"
echo "  Логи:                 docker compose logs -f"
