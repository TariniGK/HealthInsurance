WITH source_data
AS (
    SELECT member_id,
    plan_id,
    member_name,
    load_sk,
    insurance_company,
    age,
    gender,
    city,
    state,
    Policy_Start_Date,
    eligibility_status,
    Monthly_Premium_USD,
    Run_pipeline_id
    from 
    {{ source('raw','MEMBERS')}}
),

final as (
SELECT 
HASH(member_id) AS member_sk,
member_id,
plan_id,
load_sk,
insurance_company,
CAST(age AS INT) AS member_age,
gender,
trim(member_name) as member_name,
CAST(policy_start_date AS DATE) AS start_date,
eligibility_status,
CAST(Monthly_Premium_USD AS NUMBER(10,2)) as monthly_premium_USD,
Run_pipeline_id AS adf_run_id,
city,
state,
case when eligibility_status = 'ACTIVE' THEN 'ACTIVE'
else 'NON-ACTIVE'
end as status,
object_construct()
FROM source_data
QUALIFY row_number() over( partition by member_id order by policy_start_date desc) = 1
)

select * from final