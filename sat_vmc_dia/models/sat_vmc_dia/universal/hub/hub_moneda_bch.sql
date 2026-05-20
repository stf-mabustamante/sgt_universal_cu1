{{ config ( materialized='incremental', 
            unique_key =['moneda_cod_bch'],
            schema= 'sgt',
            alias="hub_moneda_bch")
}}

{% set table_exists_moneda_bch = exists_table('production_universal_sgt', 'hub_moneda_bch') %}

{% if table_exists_moneda_bch %}

{{ log("Cargando novedades", info=True) }}

WITH novedades AS (
        SELECT msat.*
        
        FROM (
            SELECT DISTINCT {{ attr_hub_moneda_bch() }}
            FROM {{ ref('sat_vmc_dia') }}
            WHERE vmc_cod_mnd_bch IS NOT NULL 
            AND periodo_dia = '{{var("periodo")}}'
        ) msat
        LEFT JOIN {{ source('production_universal_sgt', 'hub_moneda_bch') }} hub
        ON msat.moneda_cod_bch = hub.moneda_cod_bch
        WHERE hub.moneda_cod_bch IS NULL
    )

    -- Carga solo novedades en la tabla
    SELECT DISTINCT * FROM novedades

{% else %}

    {{ log("Creando tabla hub_moneda_bch para el proyecto SGT", info=True) }}

    SELECT *
    FROM
    (SELECT DISTINCT {{ attr_hub_moneda_bch() }}
    FROM {{ ref('sat_vmc_dia') }}
    WHERE vmc_cod_mnd_bch IS NOT NULL AND periodo_dia = '{{var("periodo")}}')

{% endif %}
    