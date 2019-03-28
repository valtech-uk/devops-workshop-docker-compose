.PHONY : postman
.DEFAULT_GOAL := build

setup:
	@[[ -e ".env" ]] || cp .env.dist .env
	@[[ -e "docker-compose.local.yml" ]] || cp docker-compose.local.yml.dist docker-compose.local.yml

build:
	@docker-compose run --rm maven
	@docker-compose build api postman liquibase

run:
	@docker-compose up api

stop:
	@docker-compose stop

sonar-check:
	@docker-compose run --rm sonar-check

liquibase:
	@docker-compose run --rm liquibase

db-truncate:
	@docker-compose up -d db
	@docker-compose exec -T db sh -c \
		'exec mysql -u$$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE' <<< "TRUNCATE notes;" 2> /dev/null

test: db-truncate
	@docker-compose run --rm postman
