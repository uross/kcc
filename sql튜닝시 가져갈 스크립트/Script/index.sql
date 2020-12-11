col index_name for a30;
col table_name for a30;
col column_name for a30;
select  a.table_name,
        a.index_name,
        a.column_name,
        a.column_position
from    dba_ind_columns a
where   a.index_owner = 'OMPDBA'
and     a.table_name = upper('&TABLE')
order by 1,2,4
/
