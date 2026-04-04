# Smart quiz to collect applications for the development of a room design project.
git clone 
copy .env.example .env
copy frontend/.env.example frontend/.env
docker compose up -d --build


Чтобы посмотреть JSON со всеми заявками: http://localhost:3000/api/v1/leads?secret=super_hackathon_key

Чтобы скачать CSV-файл (например, для Excel): http://localhost:3000/api/v1/leads.csv?secret=super_hackathon_key