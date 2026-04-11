#!/usr/bin/env bash

set -euo pipefail

SOURCE="carto-demo-data:demo_tilesets.osm_buildings"
DEST_PROJECT="${BQ_DEST_PROJECT:?Set BQ_DEST_PROJECT env var}"
DEST_DATASET="${BQ_DEST_DATASET:-osm_replica}"
DEST_TABLE="${BQ_DEST_TABLE:-osm_buildings}"
DEST="${DEST_PROJECT}:${DEST_DATASET}.${DEST_TABLE}"
LOCATION="${BQ_LOCATION:-EU}"

if ! command -v bq &> /dev/null; then
  echo "Missing bq command. Install Google Cloud CLI: https://cloud.google.com/sdk/docs/install"
  exit 1
fi

echo "[$(date -u +%FT%TZ)] Starting replication: ${SOURCE} -> ${DEST}"

# Ensure destination dataset exists
bq --project_id="${DEST_PROJECT}" mk \
  --dataset \
  --location="${LOCATION}" \
  --description="Stable replica of OSM buildings tileset" \
  "${DEST_PROJECT}:${DEST_DATASET}" 2>/dev/null || true

# Copy table, overwriting destination to keep it consistent with source
bq cp \
  --project_id="${DEST_PROJECT}" \
  --location="${LOCATION}" \
  --force \
  --no_async \
  "${SOURCE}" \
  "${DEST}"

echo "[$(date -u +%FT%TZ)] Replication complete."
