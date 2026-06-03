with source AS (
select 
claim_id,
member_id,
load_sk,
run_pipeline_id,
provider_id,
claim_type,
service_date,
claim_amount,
paid_amount,
claim_status,
diagnosis_code,
created_at
from {{ source('raw', 'CLAIMS') }}),

final AS (
    SELECT 
    HASH(member_id) AS member_sk,
    'CLM' || lpad(REGEXP_REPLACE(claim_id,'[^0-9]',''),6,0) AS claim_id,
    load_sk,
    run_pipeline_id AS adf_run_id,
    'PRV' || lpad(REGEXP_REPLACE(provider_id,'[^0-9]',''),6,0) AS provider_id,
    claim_type,
    service_date,
    CAST(claim_amount AS NUMBER(10,2)) AS claim_amount,
    CAST(paid_amount AS NUMBER(10,2)) AS paid_amount,
    claim_status,
    diagnosis_code,
    created_at
    FROM source
    QUALIFY row_number() OVER(partition by member_id,claim_id ORDER BY created_at DESC ) = 1

)

SELECT * FROM final