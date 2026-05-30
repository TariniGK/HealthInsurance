select *
from {{ source('raw', 'MEMBERS') }}