docker network create web-exame-net 

#Executar PG
docker run \
       --rm \
       --name PGExame \
       -d \
       -v webExameBD:/var/lib/postgresql/data \
       -e POSTGRES_PASSWORD=admin \
       -e POSTGRES_USER=admin \
       -e POSTGRES_DB=db \
       --network=web-exame-net \
       postgres:13.16


docker run \
       -d \
       --rm \
       --name redis \
       --network=web-exame-net \
       redis/redis-stack:latest


docker run \
       --rm \
       --name sidekiq \
       -d \
       -w /app \
       -v $(pwd):/app \
       -v rubygems:/usr/local/bundle \
       --network=web-exame-net \
       -e REDIS_URL=redis://redis:6379/0 \
       ruby:3.2.5 \
       sh -c "bundle install && sidekiq -r ./app/jobs/import_csv_job.rb"


docker run \
       --rm \
       --name rubyWebExame \
       -it \
       -w /app \
       -v $(pwd):/app \
       -v rubygems:/usr/local/bundle \
       -p 4567:4567 \
       --network=web-exame-net \
       -e REDIS_URL=redis://redis:6379/0 \
       ruby:3.2.5 \
       sh -c  "bundle install && puma -p 4567"



       


