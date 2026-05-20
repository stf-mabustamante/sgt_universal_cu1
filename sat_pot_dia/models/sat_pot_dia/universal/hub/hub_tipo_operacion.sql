{{ config ( materialized='incremental', 
            unique_key =['tipope_cod_tipo_operacion'],
            schema= 'sgt',
            alias="hub_tipo_operacion")
}}

{% set table_exists_hub_cheque = exists_table('production_universal_sgt', 'hub_tipo_operacion') %}

{% if table_exists_hub_cheque %}

{{ log("Cargando novedades", info=True) }}

WITH novedades AS (
        SELECT msat.*
        
        FROM (
            SELECT DISTINCT {{ attr_hub_tipo_operacion() }}
            FROM {{ ref('sat_pot_dia') }}
            WHERE pot_cod_to IS NOT NULL 
            AND periodo_dia = '{{var("periodo")}}'
        ) msat
        LEFT JOIN {{ source('production_universal_sgt', 'hub_tipo_operacion') }} hub
        ON msat.tipope_cod_tipo_operacion = hub.tipope_cod_tipo_operacion
        WHERE hub.tipope_cod_tipo_operacion IS NULL
    )

    -- Carga solo novedades en la tabla
    SELECT DISTINCT * FROM novedades

{% else %}

    {{ log("Creando tabla hub_tipo_operacion para el proyecto SGT", info=True) }}

    SELECT DISTINCT {{ attr_hub_tipo_operacion() }}
    FROM {{ ref('sat_pot_dia') }}
    WHERE pot_cod_to IS NOT NULL AND periodo_dia = '{{var("periodo")}}'

{% endif %}
    