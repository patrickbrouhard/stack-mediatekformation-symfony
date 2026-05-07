# MySQL

Ce répertoire contient les éléments liés au service MySQL.

## Initialisation (scripts)
- `docker/mysql/init/` est monté dans `/docker-entrypoint-initdb.d`
- Tous les scripts `*.sql` présents seront exécutés au premier démarrage du conteneur (si la base n’existe pas encore)

> Note : si on change les scripts après coup, MySQL ne les rejouera pas automatiquement si le volume de données existe déjà.

## Seed / import
Le script `scripts/import-app.sh` :
- clone l’application Symfony dans `app/mediatekformation` (si absente)
- copie `app/mediatekformation/sql/seed.sql` vers `docker/mysql/init/`

Lancer :
```bash
bash scripts/import-app.sh
```

## Données
Les données MySQL sont persistées dans le volume `db_data` (défini dans `docker-compose.yml`).

Pour repartir de zéro (⚠️ destructif) :
```bash
docker compose down
docker volume rm <project>_db_data
docker compose up -d
```

## Accès
- Port hôte : `3306`
- phpMyAdmin : http://localhost:8081

## Dépannage rapide
Voir les logs :
```bash
docker logs mediatek_db --tail 200
```

Se connecter au conteneur :
```bash
docker exec -it mediatek_db mysql -uroot -p
```