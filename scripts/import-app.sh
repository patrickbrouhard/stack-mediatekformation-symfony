#!/usr/bin/env bash

set -e

APP_DIR="../app/mediatekformation"
MYSQL_INIT_DIR="../docker/mysql/init"
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