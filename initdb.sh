#!/bin/bash

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the 'template_db' template db
psql <<-EOSQL
CREATE DATABASE template_db;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_db';
EOSQL

# Load extensions into both template_database and $POSTGRES_DB
for DB in template_db "$POSTGRES_DB"; do
	echo "Loading extensions into $DB"
	psql -v ON_ERROR_STOP=1 --dbname "$DB" <<-EOSQL
		CREATE EXTENSION IF NOT EXISTS postgis;
		CREATE EXTENSION IF NOT EXISTS postgis_topology;
		CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
        CREATE EXTENSION IF NOT EXISTS pg_trgm;
        CREATE TEXT SEARCH DICTIONARY pl_ispell (
            Template = ispell,
            DictFile = polish,
            AffFile = polish,
            StopWords = polish
        );

        CREATE TEXT SEARCH CONFIGURATION pl_ispell(parser = default);

        ALTER TEXT SEARCH CONFIGURATION pl_ispell
            ALTER MAPPING FOR asciiword, asciihword, hword_asciipart, word, hword, hword_part
            WITH pl_ispell;
EOSQL
done
