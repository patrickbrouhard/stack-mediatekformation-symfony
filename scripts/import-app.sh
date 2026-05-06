#!/usr/bin/env bash

set -e # Arrête le script en cas d'erreur

# Chemin absolu du dossier où se trouve le script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Racine du projet = dossier parent du dossier scripts/
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

APP_DIR="$PROJECT_ROOT/app/mediatekformation"
MYSQL_INIT_DIR="$PROJECT_ROOT/docker/mysql/init"
REPO_URL="https://github.com/patrickbrouhard/mediatekformation.git"

# Clonage du dépôt GitHub si absent
if [ ! -d "$APP_DIR" ]; then
    echo "Clonage du dépôt GitHub..."
    git clone "$REPO_URL" "$APP_DIR"
else
    echo "✔ dépôt déjà présent"
fi

# Copie du script sql depuis APP_DIR/sql vers le répertoire docker/mysql/init
fichier="$APP_DIR/sql/seed.sql"

if [ ! -f "$fichier" ]; then
    echo "Erreur : Le fichier $fichier est introuvable"
    exit 1
fi
cp "$fichier" "$MYSQL_INIT_DIR/"

echo "✔ Script SQL copié avec succès dans $MYSQL_INIT_DIR/"