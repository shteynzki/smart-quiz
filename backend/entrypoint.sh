#!/bin/sh

echo "=====Running migrations====="
bundle exec rails db:migrate

rm -f /app/tmp/pids/server.pid
exec bundle exec rails server -b 0.0.0.0 -p "${PUMA_PORT:-3000}"
