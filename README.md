# Smart Quiz

Приложение для сбора заявок на дизайн-проект помещения.

Проект состоит из:
- `frontend` на `Vue 3 + TypeScript + Vite`
- `backend` на `Ruby on Rails API`
- `PostgreSQL`
- `Docker Compose` для запуска

## Стек

- Frontend: Vue 3, TypeScript, Vite, Pinia, Vue Router, Axios
- Backend: Rails 8, Puma, Pagy, Rack::Cors, Rack::Attack, Rswag
- Database: PostgreSQL 16
- AI: `ruby-openai` client c `NVIDIA` endpoint

## Структура

```text
.
├── frontend/        # SPA-клиент
├── backend/         # Rails API
├── docker-compose.yml
├── .env.example
└── README.md
```

## Быстрый старт

### 1. Подготовить переменные окружения

В корне проекта:

```bash
cp .env.example .env
```

Для фронтенда:

```bash
cp frontend/.env.example frontend/.env
```

### 2. Запустить проект

```bash
docker compose up -d --build
```

После запуска:
- frontend: `http://localhost:3000`
- backend: `http://localhost:8000`

## Основные переменные окружения

Файл: [.env.example]

- `FRONT_PORT=3000` - внешний порт фронтенда
- `BACK_PORT=8000` - внешний порт backend
- `PUMA_PORT=3000` - внутренний порт Rails в контейнере
- `RAILS_API=/api/v1` - базовый префикс API
- `HOST=http://localhost` - базовый хост для ссылок
- `DB_HOST=postgres` - адрес Postgres внутри Docker сети
- `LEADS_EXPORT_SECRET=supersecret` - секрет для выгрузки лидов
- `SMTP_*` - настройки почты
- `TELEGRAM_*` - настройки Telegram
- `NVIDIA_*` - ключ и модель для AI-чата

## Полезные команды

Запуск:

```bash
docker compose up -d --build
```

Остановка:

```bash
docker compose down
```

Логи backend:

```bash
docker compose logs -f backend
```

Логи frontend:

```bash
docker compose logs -f frontend
```

Перегенерировать Swagger:

```bash
docker compose exec backend bundle exec rake rswag:specs:swaggerize
```

## API и полезные ссылки

Swagger UI:

```text
http://localhost:8000/api/v1/api-docs
```

Создание лида:

```text
POST /api/v1/leads
```

AI-чат:

```text
POST /api/v1/chat
```

Webhook Telegram:

```text
POST /api/v1/telegram/webhook
```

Просмотр заявок в JSON:

```text
http://localhost:8000/api/v1/leads?secret=YOUR_SECRET
```

Скачать заявки в CSV:

```text
http://localhost:8000/api/v1/leads.csv?secret=YOUR_SECRET
```

Вместо `YOUR_SECRET` используйте значение `LEADS_EXPORT_SECRET` из `.env`.

## Тесты

Если зависимости установлены внутри контейнера:

```bash
docker compose exec backend bundle exec rspec
```

## Как устроен запуск

- `postgres` поднимается первым
- `backend` ждет Postgres и запускает Rails
- `frontend` собирается отдельно и публикуется на `FRONT_PORT`

## Примечания

- В проекте есть CORS-настройка для фронтенда через `HOST` и `FRONT_PORT`
- В backend включена базовая защита через `Rack::Attack`
- Swagger-файл генерируется из `rswag`-spec'ов в `backend/spec`
