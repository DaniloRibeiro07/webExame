docker network create web-exame-net 

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
       --rm \
       --name chrome-server \
       --network=web-exame-net \
       -d \
       -v $(pwd):/usr/src/app \
       selenium/standalone-chrome:127.0

docker run \
       --rm \
       --name rubyWebExameTeste \
       -it \
       -w /app \
       -v $(pwd):/app \
       -v rubygems:/usr/local/bundle \
       --network=web-exame-net \
       ruby:3.2.5 \
       sh -c "bundle install && rspec"
