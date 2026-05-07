# Grafana

Grafana sert à visualiser :
- les métriques (Prometheus)
- les logs (Loki)

## Accès
- URL : http://localhost:3000
- Identifiants (dev) : `admin` / `admin`

## Provisioning (auto-configuration)
Le provisioning est activé pour que tout fonctionne dès le premier `docker compose up`.

### Datasources
Définies dans :
- `docker/monitoring/grafana/provisioning/datasources/datasources.yml`

On provisionne au minimum :
- Prometheus (uid: `prometheus`)
- Loki (uid: `loki`)

### Dashboards
Provider défini dans :
- `docker/monitoring/grafana/provisioning/dashboards/dashboards.yml`

Les JSON sont chargés depuis :
- `docker/monitoring/grafana/dashboards/`

Dashboards présents :
- `cadvisor-exporter-14282.json` : métriques par conteneur (cAdvisor / Prometheus)
- `app-logs-loki.json` : logs nginx / php (Loki)

## Ajouter un dashboard
1) Exporter ou récupérer un dashboard au format JSON
2) Le déposer dans `docker/monitoring/grafana/dashboards/`
3) Attendre le `updateIntervalSeconds` (ou redémarrer Grafana)

Redémarrage :
```bash
docker compose -f docker-compose.monitoring.yml up -d --force-recreate grafana
```

## Remarque sur la persistance
Le volume `grafana_data` contient la base interne Grafana (users, dashboards modifiés via l’UI, etc.).
En cas de test “from scratch”, supprimer ce volume réinitialise Grafana.