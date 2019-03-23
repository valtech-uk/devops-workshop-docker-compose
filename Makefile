.DEFAULT_GOAL := build

setup:
	@[[ -e ".env" ]] || cp .env.dist .env
	@[[ -e "docker-compose.local.yml" ]] || cp docker-compose.local.yml.dist docker-compose.local.yml

build:
	@docker-compose build api

run:
	@docker-compose up api

sonar:
	@docker-compose up -d sonar

db-truncate:
	@docker-compose up -d db
	@docker-compose exec -T db sh -c \
		'exec mysql -u$$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE' <<< "TRUNCATE notes;"

postman: db-truncate
	@docker-compose run --rm postman
