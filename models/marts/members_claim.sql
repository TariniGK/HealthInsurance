WITH intermediate_data AS 
(
    SELECT * FROM {{ ref('int_members_claims')}}
),

final AS (

    SELECT 
        claim_id AS Claim_id,
        member_id AS Member_id,
        member_name AS Patient_Name,
        claim_type AS Care_Setting,
        service_date,
        previous_claim_amount AS Prior_Visit_Billed_Amount_USD,
        next_service_date     AS Next_Scheduled_Visit_Date,
        CASE WHEN claim_amount >= 5000 THEN 'Tier 1 : High Cost Case'
        WHEN claim_amount BETWEEN 1000 AND 4999 THEN 'Tier 2: Moderate Cost Case'
        ELSE 'Tier 3: Low Cost Case'
        END AS Case_Cost_Severity,
        FROM 
        intermediate_data
        WHERE claim_id IS NOT NULL


)

SELECT * from final