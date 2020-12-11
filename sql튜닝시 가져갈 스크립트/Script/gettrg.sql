col table_name for a30
col trigger_owner for a10
col trigger_name for a30
select  distinct a.table_name,
        a.trigger_owner,
        a.trigger_name
from    dba_trigger_cols a
where   0=0
and     a.trigger_owner = 'OMPDBA'
and     a.table_name in upper('&TABLE_NAME')
/
