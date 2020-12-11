select  no,
        hash_value,
        SQL_1
from    (
        select  1 as no,
                'Hash-Value : '||hash_value as hash_value,
                translate(dbms_lob.substr(a.sql_fulltext,3800,1),':','&') as SQL_1,
                'Executions : '||a.executions as exec,
                'SQLID : '||sql_id
        from    v$sqlarea a
        where   0=0
        and     upper(a.sql_text) not like '%BEGIN%'
        and     upper(a.sql_text) not like '%SQLAREA%'
        and     upper(a.sql_text) not like '%DBA_%'
        and     upper(a.sql_text) not like '%USER_%'
        and     upper(a.sql_text) not like '%ALL_%'
        and     upper(a.sql_text) not like '%V$SQL%'
        and     a.hash_value = '&SQLHASH'
        union
        select  2 as no,
                'Hash-Value : '||hash_value as hash_value,
                translate(dbms_lob.substr(a.sql_fulltext,5000,3801),':','&') as SQL_2,
               'Executions : '||a.executions as exec,
                'SQLID : '||sql_id
        from    v$sqlarea a
        where   0=0
        and     upper(a.sql_text) not like '%BEGIN%'
        and     upper(a.sql_text) not like '%SQLAREA%'
        and     upper(a.sql_text) not like '%DBA_%'
        and     upper(a.sql_text) not like '%USER_%'
        and     upper(a.sql_text) not like '%ALL_%'
        and     upper(a.sql_text) not like '%V$SQL%'
        and     a.hash_value = '&SQLHASH'
        )
order by no
/
