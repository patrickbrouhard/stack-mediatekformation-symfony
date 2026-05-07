# PHP (PHP-FPM)

Ce répertoire contient l’image PHP utilisée pour exécuter l’application Symfony (PHP-FPM).

## Contenu
- `Dockerfile` : build de l’image PHP (extensions, dépendances…)
- (éventuels fichiers `.ini` / conf) : selon tes besoins

## Rôle dans le stack
Défini dans `docker-compose.yml` :
- service `php` construit via `./docker/php`
- code monté depuis `./app/mediatekformation` vers `/var/www/mediatekformation`
- `working_dir` : `/var/www/mediatekformation`

Variables d’environnement utilisées (extrait) :
- `APP_ENV`
- `APP_SECRET`
- `DATABASE_URL`

Ces valeurs viennent du `.env` / `.env.example` à la racine.

## Logs
Les logs PHP-FPM / Symfony (stdout/stderr) sont consultables via Docker :
```bash
docker logs mediatek_php --tail 200
```

Et via Loki (si la stack monitoring est démarrée) :
```logql
{compose_service="php"}
```

## Dépannage rapide
Entrer dans le conteneur :
```bash
docker exec -it mediatek_php bash
```

ou
```bash
make php (alias pour "docker compose exec php bash")
```

Vérifier la version PHP :
```bash
php -v
```