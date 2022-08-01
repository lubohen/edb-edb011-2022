#!/usr/bin/env bash

service=$1

dbt_setup () {
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
  cd /opt/dbt/prj3_ingestao
  if dbt debug ; then
      echo "The 'dbt debug' verification succeeded"
  else
      echo "The 'dbt debug' verification failed. Check if the profiles.yml, project.yml are valid and git is installed"
      exit 1
  fi
}


echo "Starting DB"
if [ $service = "webserver" ]
then
  airflow db check
  airflow db init
  airflow connections add 'postgres_dbt' \
      --conn-type 'postgresql' \
      --conn-login 'admin' \
      --conn-password 'admin' \
      --conn-host 'postgres_dbt' \
      --conn-port '5432' \
      --conn-schema 'trusted'
  airflow users create -e admin@test.com -f admin -l admin -p admin -u admin -r Admin
else
  echo "Executing DBT setup"
  dbt_setup
fi
echo "Starting" $service
airflow $service