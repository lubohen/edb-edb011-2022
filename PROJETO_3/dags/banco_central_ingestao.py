from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
import requests
import pandas as pd
import numpy as np

caminho_raw = '/media/tchaikovsky/DataResearch/mt/air-dbt-ge/data/raw/'

def importar_arquivos_brutos():
    df_consolidado = pd.read_csv(caminho_raw + '/df_consolidado.csv', encoding='latin1')
    df_lista_inst = pd.read_csv(caminho_raw + '/df_lista_inst.csv', encoding='latin1')
    df_reclamações = pd.read_csv(caminho_raw + '/df_reclamações.csv', encoding='latin1')
    df_tarifas = pd.read_csv(caminho_raw + '/df_tarifas.csv', encoding='latin1')


lista_bases = ['df_consolidado','df_lista_inst','df_reclamações','df_tarifas']

def limpeza_bases_origem():
    for base in lista_bases:
        new_base = print(base+"_normal")
        new_base = base.copy()
        new_base = new_base.drop(['Unnamed: 0'], axis=1, inplace=True)
        new_base = new_base.drop_duplicates(subset=['codigo_grupo'], inplace=True)



with DAG(
    "banco_central_ingestao",
    default_args={
        "depends_on_past": False,
        "email_on_failure": False,
        "email_on_retry": False,
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
    },
    description="A dag that generates the banco_central_ingestao",
    schedule_interval=None,
    start_date=datetime(2022, 7, 31),
    catchup=False,
    tags=["project3", "dbt", "python"],
) as dag:

    t1 = PythonOperator(
        task_id="importar_arquivos_brutos",
        python_callable=importar_arquivos_brutos,
    )

    t2 = PythonOperator(
        task_id="limpeza_bases_origem",
        python_callable=limpeza_bases_origem,
    )

    t3 = BashOperator(
        task_id="dbt_normalizacao",
        bash_command="dbt run --project-dir /opt/dbt/prj3_ingestao",
    )

    t4 = BashOperator(
        task_id="dbt_gera_documentacao",
        bash_command="dbt docs generate --project-dir /opt/dbt/prj3_ingestao",
    )

    

    t1 >> t2 >> t3 >> t4
