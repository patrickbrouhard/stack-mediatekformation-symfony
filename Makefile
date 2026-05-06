up:
	docker compose up -d

down:
	docker compose down

reset-db: # Supprime conteneurs, volumes, réseaux et images
	docker compose down -v

build: " # Construit les images Docker et démarre les conteneurs
	docker compose up -d --build

logs:
	docker compose logs -f

php:
	docker compose exec php bash

composer: # Installe les dépendances PHP avec Composer
	docker compose exec -T php composer install

migrate: # Initialise la base de données en exécutant les migrations Doctrine
	docker compose exec -T php php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration

test:
	docker compose exec -T php php bin/phpunit

import-app: # Importe une application Symfony depuis un dépôt Git et copie son script sql
	./scripts/import-app.sh

init: # Installation complète sans reset DB
	make build
	make import-app
	make composer
	make migrate

fresh: # Installation complète avec reset DB
	make reset-db
	make init