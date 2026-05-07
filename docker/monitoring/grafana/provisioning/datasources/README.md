# Provisioning des dashboards Grafana

Ce répertoire contient la configuration permettant à Grafana de charger automatiquement des dashboards depuis des fichiers JSON.  
Le provisioning évite d’avoir à importer manuellement les dashboards dans l’interface Grafana.

## Fichier : `dashboards.yml`

Ce fichier définit un *provider* Grafana qui :

- surveille le dossier `/var/lib/grafana/dashboards`
- recharge les dashboards toutes les 10 secondes
- permet l’édition et la suppression depuis l’interface Grafana
- place les dashboards dans le dossier racine de Grafana

## Ajouter un dashboard

1. Exporter un dashboard depuis Grafana au format JSON.  
2. Déposer le fichier JSON dans le dossier monté dans le conteneur à l’emplacement :  
   `/var/lib/grafana/dashboards`
3. Grafana le chargera automatiquement dans les 10 secondes.

## Objectif

Ce mécanisme garantit que les dashboards sont versionnés, reproductibles et automatiquement provisionnés lors du déploiement Docker.

## Note

Les chemins donnés sont internes à Docker, il faut donc voir la correspondance avec les chemins locaux grâce au montage de volumes défini dans `docker-compose.monitoring.yml`.

Exemple : le dossier local `./docker/monitoring/grafana/dashboards` est monté dans le conteneur à l’emplacement `/var/lib/grafana/dashboards`.