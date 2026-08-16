#!/bin/bash
# Creates a folder under Dokumentasjon/V1/skjemamodeller for every schema in Schema/V1,
# named after the schema's $id (without the .schema.json suffix), matching the folders
# already created for the felles schemas. Safe to re-run - existing folders are left as is.
# Only creates the folder; add the schema.puml class diagram by hand afterwards.

set -euo pipefail

for schema in Schema/V1/*.schema.json; do
    id=$(basename "$schema" .schema.json)
    mkdir -p "Dokumentasjon/V1/skjemamodeller/$id"
done
