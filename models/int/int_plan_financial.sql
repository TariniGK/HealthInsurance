

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

SELECT plan_id , insurance_company ,
COUNT(*) AS total_claims,
SUM(claim_amount) AS total_billed_amount,
SUM(paid_amount) AS total_paid_amount
FROM joined
GROUP BY plan_id , insurance_company 