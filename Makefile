up:
	docker compose up -d

down:
	docker compose down

reset-db:
	docker compose down -v

build:
	docker compose up -d --build

logs:
	docker compose logs -f

php:
	docker compose exec php bash

composer:
	docker compose exec -T php composer install

migrate:
	docker compose exec -T php php bin/console doctrine:migrations:migrate

test:
	docker compose exec -T php php bin/phpunit

init:
	make build
	make composer
	make migrate

fresh:
	make reset-db
	make build
	make composer
	make migrate