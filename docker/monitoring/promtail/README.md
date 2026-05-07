# Promtail (collecte des logs)

Promtail collecte les logs Docker et les envoie dans **Loki**.

Configuration : `docker/monitoring/promtail/promtail-config.yml`

## Principe
- Promtail utilise la **découverte Docker** (`docker_sd_configs`) via le socket `/var/run/docker.sock`.
- Il enrichit les logs avec des labels utiles, notamment :
  - `container` (nom du conteneur, ex: `mediatek_nginx`)
  - `compose_service` (service docker-compose, ex: `nginx`, `php`, `db`)
  - `compose_project` (projet docker-compose)
  - `image`

Ces labels permettent ensuite de filtrer dans Grafana (Explore / dashboards).

## Dépendances / volumes
Dans `docker-compose.monitoring.yml`, promtail monte :
- `/var/run/docker.sock:/var/run/docker.sock:ro` (découverte Docker)
- `/var/lib/docker/containers:/var/lib/docker/containers:ro` (fichiers de logs Docker)
- (optionnel) `/var/log:/var/log:ro` (logs système, si besoin)

## Vérifier que Promtail fonctionne
Logs Promtail :

```bash
docker logs mediatek_promtail --tail 200
```

Tu dois voir des lignes du type :
- `added Docker target containerID=...`

## Requêtes LogQL utiles (Grafana > Explore > Loki)
Tous les logs collectés :
```logql
{job="docker"}
```

Logs nginx :
```logql
{compose_service="nginx"}
```

Logs PHP :
```logql
{compose_service="php"}
```

Logs d’un conteneur précis :
```logql
{container="mediatek_nginx"}
```

Filtrer sur erreurs (exemples) :
```logql
{compose_service="nginx"} |~ " 4[0-9]{2} | 5[0-9]{2} "
```

## Note sur l’historique
Promtail est un agent de collecte “temps réel” : selon le fichier `positions`, il peut ne lire que les nouvelles lignes.