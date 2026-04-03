#!/bin/sh

# echo "=====Running migrations====="
# bundle exec rails db:migrate

# if [ "$RAILS_ENV" = "development" ] || [ -z "$RAILS_ENV" ]; then
#   if bundle exec rails db:exists?; then
#     echo "=====Database already seeded====="
#   else
#     echo "=====Seeding database====="
#     bundle exec rails db:seed
#   fi
# fi
rm -f /app/tmp/pids/server.pid
exec bundle exec rails server -b 0.0.0.0 -p 3000