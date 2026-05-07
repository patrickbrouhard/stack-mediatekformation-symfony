# Stack monitoring (observabilité)

Ce répertoire contient la configuration Docker du stack d’observabilité utilisé avec ce projet.

Elle est démarrée via `docker-compose.monitoring.yml` à la racine.

## Composants
- **Prometheus** : collecte des métriques (scrape)
- **cAdvisor** : expose des métriques par conteneur Docker (CPU, RAM, réseau…)
- **Loki** : stockage / requêtage des logs
- **Promtail** : collecte des logs Docker et les pousse à Loki
- **Grafana** : visualisation (dashboards + Explore)

## Démarrage
Depuis la racine du projet :

```bash
docker network create mediatek_net 2>/dev/null || true
docker compose -f docker-compose.monitoring.yml up -d
```

## Accès (ports)
- Grafana : http://localhost:3000 (admin/admin par défaut)
- Prometheus : http://localhost:9090
- Loki : http://localhost:3100
- cAdvisor : http://localhost:8082

## Où sont les fichiers de configuration ?
- Prometheus : `docker/monitoring/prometheus/prometheus.yml`
- Loki : `docker/monitoring/loki/loki-config.yml`
- Promtail : `docker/monitoring/promtail/promtail-config.yml`
- Grafana provisioning :
  - datasources : `docker/monitoring/grafana/provisioning/datasources/`
  - dashboards provider : `docker/monitoring/grafana/provisioning/dashboards/`
  - dashboards JSON : `docker/monitoring/grafana/dashboards/`

## Volumes Docker
La stack monitoring utilise des volumes persistants (définis dans `docker-compose.monitoring.yml`) :
- `grafana_data` : base Grafana (users, prefs…)
- `prometheus_data` : TSDB Prometheus
- `loki_data` : données Loki

## Redémarrage “propre” (si besoin)
Si tu veux repartir de zéro (⚠️ efface les données) :

```bash
docker compose -f docker-compose.monitoring.yml down
docker volume rm <project>_grafana_data <project>_prometheus_data <project>_loki_data
docker compose -f docker-compose.monitoring.yml up -d
```