# Projet Symfony Dockerisé

## Lancer le projet

```bash
make up
```

## Tests

```bash
make test
```

## Stack
- Nginx
- PHP-FPM
- MySQL
- phpMyAdmin

## Infra

Terraform + Ansible (en cours)


# stack-mediatekformation-symfony

Stack Docker pour exécuter l’application Symfony **[mediatekformation](https://github.com/patrickbrouhard/mediatekformation)** + un stack d’observabilité (Prometheus / Loki / Grafana).

## Prérequis
- Docker + Docker Compose v2 (`docker compose`)

Création du réseau si besoin :
```bash
docker network create mediatek_net
```

## Arborescence (résumé)
- `docker-compose.yml` : stack application (nginx, php-fpm, mysql, phpMyAdmin)
- `docker-compose.monitoring.yml` : stack monitoring (prometheus, grafana, loki, promtail, cadvisor)
- `docker/` : configuration des services (app + monitoring)
- `app/` : répertoire qui contient l’application clonée (`app/mediatekformation`)
- `scripts/import-app.sh` : clone l’app Symfony + copie `seed.sql` dans `docker/mysql/init`

## 1) Importer l’application Symfony
Ce dépôt ne contient pas directement l’application Symfony : elle est clonée dans `app/mediatekformation` depuis le dépôt [mediatekformation](https://github.com/patrickbrouhard/mediatekformation).

```bash
bash scripts/import-app.sh
```

**NB : ce script copie aussi le fichier `seed.sql` dans `docker/mysql/init` pour initialiser la base de données MySQL au démarrage du conteneur.**

*Ne pas oublier de rendre le script exécutable : `chmod +x scripts/import-app.sh`*

## 2) Lancer le stack application
```bash
docker compose up -d
```

Services exposés :
- Application (nginx) : http://localhost:8080
- phpMyAdmin : http://localhost:8081
- MySQL : localhost:3306

## 3) Lancer le stack monitoring
```bash
docker compose -f docker-compose.monitoring.yml up -d
```

Services exposés :
- Prometheus : http://localhost:9090
- Grafana : http://localhost:3000 (login: `admin` / `admin`)
- Loki : http://localhost:3100
- cAdvisor : http://localhost:8082

### Grafana : provisioning automatique
Grafana est provisionné automatiquement au démarrage :
- Datasources : Prometheus + Loki (voir `docker/monitoring/grafana/provisioning/datasources/datasources.yml`)
- Dashboards : chargés depuis `docker/monitoring/grafana/dashboards/` (voir `docker/monitoring/grafana/provisioning/dashboards/dashboards.yml`)

Dashboards fournis :
- `cadvisor-exporter-14282.json` : métriques par conteneur (CPU, RAM, réseau…)
- `app-logs-loki.json` : logs nginx / php via Loki

## 4) Tests
```bash
make test
```

## Makefile
Le `Makefile` contient des commandes pour faciliter les opérations courantes.

Exemples :
- `make up` : démarre le stack application
- `make down` : arrête le stack application
- `make test` : exécute les tests
- `make init` : installation complète (import app, build, composer, migrate, monitoring)
- `make fresh` : reset complet (arrêt + suppression volumes + réimport app + build + composer + migrate + monitoring)

Voir le `Makefile` pour la liste complète des commandes.

## Stack
### Application
- Nginx
- PHP-FPM
- MySQL
- phpMyAdmin

### Observabilité (v1)
- Prometheus
- cAdvisor (métriques conteneurs)
- Loki (logs)
- Promtail (collecte logs Docker + labels `compose_service`, `container`, etc.)
- Grafana (dashboards + explore)

## Infra
voir le dépôt [homelab](https://github.com/patrickbrouhard/homelab)

## Idées pour la suite
- Alerting minimum (exemples : alerte sur l’utilisation CPU / RAM, ou sur des erreurs dans les logs)
- Ajouter un reverse proxy Traefik pour gérer les routes + certificats (https)
- Ajouter `node exporter` pour monitorer la machine hôte (CPU, RAM, disques, etc.)
- logs Symfony JSON (Monolog) + ajustement du dashboard Grafana (par exemple filtrer `level=error`)

De manière générale, passer de logs texte à des logs structurés (JSON) facilite grandement l’exploitation via Loki + Grafana :
- des champs cliquables (level, channel, status_code, request_id…)
- des filtres précis (au lieu de regex)
- des dashboards logs plus lisibles