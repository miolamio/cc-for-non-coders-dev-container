#!/usr/bin/env bash
#
# run.sh — Собрать и запустить тестовый экземпляр локально
#
# Что делает:
#   1. Копирует курсовые материалы в build-контекст
#   2. Собирает Docker-образ
#   3. Запускает контейнер
#
# После запуска:
#   Портал: http://localhost:8080  (пароль: test123)
#
# Остановка:  docker compose down
# С удалением данных:  docker compose down -v

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Подготовка build-контекста ==="

# Копируем курсовые материалы (course/ пересоздаётся, skills/ мержится)
rm -rf "$SCRIPT_DIR/course"

mkdir -p "$SCRIPT_DIR/course"
cp -r "$PROJECT_ROOT/sessions/" "$SCRIPT_DIR/course/sessions/"
cp "$PROJECT_ROOT/CLAUDE.md" "$SCRIPT_DIR/course/CLAUDE.md"
cp "$PROJECT_ROOT/course-outline.md" "$SCRIPT_DIR/course/course-outline.md"
cp "$PROJECT_ROOT/sessions/README.md" "$SCRIPT_DIR/course/README.md"

# Skills: копируем из проекта поверх, не удаляя локальные (en-ru-translator-adv, ru-editor и др.)
mkdir -p "$SCRIPT_DIR/skills"
cp -r "$PROJECT_ROOT/.claude/skills/"* "$SCRIPT_DIR/skills/"

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
