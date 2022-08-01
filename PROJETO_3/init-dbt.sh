#!/usr/bin/env bash

mkdir ~/.dbt
touch ~/.dbt/profiles.yml
yq e '.prj3_ingestao.target = "dev"' -i ~/.dbt/profiles.yml
yq e '.prj3_ingestao.outputs.dev.type = "postgres"' -i ~/.dbt/profiles.yml
yq e '.prj3_ingestao.outputs.dev.host = "postgres_dbt"' -i ~/.dbt/profiles.yml
yq e '.prj3_ingestao.outputs.dev.port = 5432' -i ~/.dbt/profiles.yml
yq e '.prj3_ingestao.outputs.dev.user = "admin"' -i ~/.dbt/profiles.yml
yq e '.prj3_ingestao.outputs.dev.password = "admin"' -i ~/.dbt/profiles.yml
yq e '.prj3_ingestao.outputs.dev.dbname = "dbtdb"' -i ~/.dbt/profiles.yml
yq e '.prj3_ingestao.outputs.dev.schema = "specialized"' -i ~/.dbt/profiles.yml
yq e '.prj3_ingestao.outputs.dev.threads = 5' -i ~/.dbt/profiles.yml

# shellcheck disable=SC2164
cd /dbt-docs/prj3_ingestao
if dbt debug ; then
    echo "The 'dbt debug' verification succeeded"
else
    echo "The 'dbt debug' verification failed. Check if the profiles.yml, project.yml are valid and git is installed"
    exit 1
fi

dbt docs serve --port 5555 --target dev --profiles-dir ~/.dbt --profile prj3_ingestao