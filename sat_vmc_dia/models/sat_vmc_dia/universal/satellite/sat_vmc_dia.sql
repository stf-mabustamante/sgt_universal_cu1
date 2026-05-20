{{ config ( materialized='incremental',
            alias = 'sat_vmc_dia',
            schema='sgt',
            incremental_strategy = 'insert_overwrite',
            on_schema_change='append_new_columns',
            partition_by = {
            'field': 'periodo_dia', 
            'data_type': 'date',
            'granularity': 'day'
            },
            unique_key = ['periodo_dia','vmc_cod_mnd_bch']
            )}}
    
    select 
        {{ attr_sat_vmc_dia() }}
    from   
        {{ source('production_stage', 'tbl_ap0516_vmc_dia') }}
    WHERE
     periodo_dia=SAFE_CAST('{{var("periodo")}}' AS DATE)
	
	