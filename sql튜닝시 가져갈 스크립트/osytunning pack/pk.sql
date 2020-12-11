set lines 10000 pages 10000
col owner for a10
col constraint_name for a30
col column_name for a30
select  a.owner,
        a.constraint_name,
        a.table_name,
        a.column_name,
        a.position
from    dba_cons_columns a,
        (
        select  p.table_name,
                q.constraint_name
        from    dba_tables p,
                dba_constraints q
        where   p.table_name = q.table_name
        and     q.constraint_type (+) = 'P'
        and     p.owner = 'OMPDBA'
        and     p.table_name = upper('&TABLENAME')
        ) x
where   0=0
and     a.owner = 'OMPDBA'
and     a.table_name = x.table_name
and     a.constraint_name = x.constraint_name
order by position
/
