

WITH 
members AS (
    SELECT * FROM {{ ref('stg_members')}}

),

claims AS (
    SELECT * FROM {{ ref('stg_claims')}}
),

joined AS (
    SELECT * FROM members M 
    JOIN claims C
    ON M.member_sk = C.member_sk
)

select 
claim_id,
member_id,
plan_id,
insurance_company,
member_name,
provider_id,
claim_type,
service_date,
claim_amount,
LAG(claim_amount) OVER(partition by member_id ORDER BY service_date ASC) AS previous_claim_amount,
LEAD(service_date) OVER(partition by member_id ORDER BY service_date ) AS next_service_date
from joined
