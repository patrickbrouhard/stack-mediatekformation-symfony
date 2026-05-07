# Nginx

Ce répertoire contient la configuration Nginx utilisée pour servir l’application Symfony.

## Fichiers
- `default.conf` : virtual host Nginx (root, fastcgi_pass vers PHP-FPM, etc.)

## Rôle dans le stack
Défini dans `docker-compose.yml` :
- expose l’app sur http://localhost:8080
- monte le code de l'application depuis `./app/mediatekformation` vers `/var/www/mediatekformation`

## Logs
Les logs Nginx sont écrits sur stdout/stderr (Docker logs).
Avec la stack Loki/Promtail, ils sont consultables dans Grafana :

```logql
{compose_service="nginx"}
```

## Dépannage rapide
- Vérifier la conf Nginx :
```bash
docker exec -it mediatek_nginx nginx -t
```

- Recharger Nginx :
```bash
docker exec -it mediatek_nginx nginx -s reload
```

- Voir les logs :
```bash
docker logs mediatek_nginx --tail 200
```