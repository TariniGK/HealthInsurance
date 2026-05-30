select *
from {{ source('raw', 'CLAIMS') }}