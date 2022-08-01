SELECT
    DISTINCT md5(calendario) as pk_calendario, ano, trimestre
FROM {{ source('trusted', 'dim_calendario') }}