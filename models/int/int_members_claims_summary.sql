WITH members AS (

    SELECT * FROM {{ ref('stg_members') }}

),

claims AS (

    SELECT * FROM {{ ref('stg_claims') }}

),

joined AS (

    SELECT M.member_id,
    M.plan_id,
    M.member_name,
    MAX(M.monthly_premium_usd) AS monthly_premium_USD,
    M.city,
    COUNT(C.claim_id) AS claims_count,
    SUM(C.claim_amount) AS total_claim_amount,
    SUM(C.paid_amount) AS total_paid_amount
    FROM members M
    LEFT JOIN claims C
        ON M.member_sk = C.member_sk
    GROUP BY M.member_id, M.member_name, M.plan_id, M.city

)

SELECT * FROM joined
ORDER BY member_id 