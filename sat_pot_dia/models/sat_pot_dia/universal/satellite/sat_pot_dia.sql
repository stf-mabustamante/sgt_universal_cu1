{{ config ( materialized='incremental',
            alias = 'sat_pot_dia',
            schema='sgt',
            incremental_strategy = 'insert_overwrite',
            on_schema_change='append_new_columns',
            partition_by = {
            'field': 'periodo_dia', 
            'data_type': 'date',
            'granularity': 'day'
            },
            unique_key = ['periodo_dia','pot_cod_to']
            )}}
    
    select 
        {{ attr_sat_pot_dia() }}
    from   
        {{ source('production_stage', 'tbl_ap0516_pot_dia') }}
    WHERE
     periodo_dia=SAFE_CAST('{{var("periodo")}}' AS DATE)
	
	