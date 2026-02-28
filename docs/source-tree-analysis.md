# Анализ дерева исходного кода

## Структура проекта

```
cc-for-non-coders-dev-container/
│
├── .env.example               # Шаблон переменных окружения
├── .gitignore                 # Исключения для Git
├── CLAUDE.md                  # Инструкции для Claude Code (корневой)
├── Dockerfile                 # ★ Сборка образа контейнера (164 строки)
├── README.md                  # Документация проекта (русский, 225 строк)
├── docker-compose.yml         # Конфигурация Docker Compose
├── run.sh                     # Скрипт быстрого запуска
│
├── auth-gateway.py            # ★ HTTP-прокси с авторизацией (316 строк)
├── login.html                 # Страница входа (тёмная тема)
├── claude-settings.json       # Настройки безопасности Claude Code
├── code-server-settings.json  # Настройки VS Code
├── entrypoint.sh              # ★ Инициализация контейнера (81 строка)
│
├── course/                    # ★ Учебные материалы курса
│   ├── CLAUDE.md              # Контекст курса для Claude
│   ├── README.md              # Приветствие для студента
│   ├── course-outline.md      # Полный план курса (400 строк)
│   │
│   └── sessions/              # 5 учебных сессий
│       ├── 01-setup/          # Сессия 1: Знакомство (3 демо)
│       │   ├── demo/
│       │   │   ├── crm-cleanup/           # CRM из CSV
│       │   │   ├── file-organization/     # Организация файлов (33 файла)
│       │   │   └── financial-dashboard/   # Финансовый дашборд
│       │   └── slides/                    # PDF-слайды
│       │
│       ├── 02-context-skills/ # Сессия 2: Контекст и навыки (8 демо)
│       │   ├── demo/
│       │   │   ├── audience-rewrite/      # Адаптация текста
│       │   │   ├── claude-md-intro/       # CLAUDE.md — введение
│       │   │   ├── commercial-offer/      # Коммерческое предложение
│       │   │   ├── content-plan/          # Контент-план
│       │   │   ├── document-pack/         # Пакет документов
│       │   │   ├── github-skill-install/  # Установка навыков
│       │   │   ├── hr-letters/            # HR-письма
│       │   │   └── weekly-report-skill/   # Навык еженедельного отчёта
│       │   └── slides/
│       │
│       ├── 03-mcp/            # Сессия 3: MCP-серверы (5 демо)
│       │   └── demo/
│       │       ├── contract-comparison/   # Сравнение договоров
│       │       ├── investor-briefing/     # Брифинг для инвестора
│       │       ├── mcp-setup/             # Настройка MCP
│       │       ├── resume-screening/      # Скрининг резюме
│       │       └── vendor-comparison/     # Сравнение поставщиков
│       │
│       ├── 04-agents/         # Сессия 4: Агенты (7 демо)
│       │   └── demo/
│       │       ├── 360-review-reports/    # 360-обзоры
│       │       ├── landing-page/          # Лендинг
│       │       ├── meeting-protocol/      # Протокол встречи
│       │       ├── quarterly-presentation/# Квартальная презентация
│       │       ├── seo-audit/             # SEO-аудит
│       │       ├── slash-commands-and-hooks/ # Slash-команды
│       │       └── speaking-prep/         # Подготовка к выступлению
│       │
│       └── 05-agent-teams/    # Сессия 5: Команды агентов (5 демо)
│           └── demo/
│               ├── booking-bot/           # Бот бронирования
│               ├── cold-outreach/         # Холодные письма
│               ├── n8n-integration/       # Интеграция с n8n
│               ├── nps-analysis/          # NPS-анализ
│               └── portfolio-site/        # Портфолио-сайт
│
├── skills/                    # ★ 19 предустановленных навыков
│   ├── algorithmic-art/       # Генеративное искусство (JS)
│   ├── brand-guidelines/      # Гайдлайны бренда
│   ├── canvas-design/         # Визуальный дизайн (30+ шрифтов)
│   ├── doc-coauthoring/       # Совместное написание документов
│   ├── docx/                  # ★ Создание/редактирование DOCX (482 строки SKILL.md)
│   ├── en-ru-translator-adv/  # EN→RU перевод (3-шаговый)
│   ├── frontend-design/       # Фронтенд-дизайн
│   ├── internal-comms/        # Внутренние коммуникации
│   ├── mcp-builder/           # Создание MCP-серверов
│   ├── pdf/                   # ★ PDF: чтение/создание/OCR (314 строк)
│   ├── playwright-cli/        # Браузерная автоматизация
│   ├── pptx/                  # Создание презентаций PPTX
│   ├── ru-editor/             # Редактор русского текста
│   ├── skill-creator/         # Мета-навык: создание навыков
│   ├── slack-gif-creator/     # Создание GIF для Slack
│   ├── theme-factory/         # Фабрика тем (10 тем)
│   ├── web-artifacts-builder/ # Создание веб-артефактов
│   ├── webapp-testing/        # Тестирование веб-приложений
│   └── xlsx/                  # ★ Excel: создание/редактирование (292 строки)
│
└── docs/                      # Сгенерированная документация
```

**Легенда:** ★ — критические файлы / ключевые каталоги

## Критические каталоги

### Корневой уровень — инфраструктура

| Файл | Назначение | Строки |
|------|-----------|--------|
| `Dockerfile` | Полная сборка образа: ОС, пакеты, IDE, инструменты, курс | 164 |
| `auth-gateway.py` | HTTP-прокси с авторизацией и WebSocket | 316 |
| `entrypoint.sh` | Инициализация: volume, конфиг, запуск сервисов | 81 |
| `docker-compose.yml` | Оркестрация: порты, volumes, ресурсы | 38 |
| `run.sh` | One-liner для сборки и запуска | 36 |
| `login.html` | Страница входа (тёмная тема, русский) | 113 |

### `course/` — учебные материалы

- **28 демо-проектов** в 5 сессиях
- Каждый демо содержит `README.md` (инструкции для преподавателя) и данные (CSV, MD, JSON)
- Многие демо включают собственные `CLAUDE.md` (контекст для AI)
- **121 файл** в общей сложности

### `skills/` — навыки Claude Code

- **19 навыков**, каждый в отдельном каталоге
- Каждый содержит `SKILL.md` (инструкции) и `LICENSE.txt`
- Сложные навыки включают `scripts/`, `references/`, `templates/`
- Общий объём SKILL.md: ~3,500+ строк

## Точки входа

1. **Контейнер**: `entrypoint.sh` → запускает File Browser, code-server, auth-gateway
2. **Веб**: `auth-gateway.py` на порту 8080 — единственная точка доступа
3. **Студент**: Открывает `http://host:8080` → логин → IDE

## Ключевые конфигурационные файлы

| Файл | Что конфигурирует |
|------|------------------|
| `.env.example` | Пароль, API-ключ, модели, таймаут |
| `claude-settings.json` | Разрешения команд, API-endpoint, модели |
| `code-server-settings.json` | Внешний вид VS Code |
| `docker-compose.yml` | Порты, volumes, ресурсы |
