select  distinct no,
        hash_value,
        sql_1
from    (
        select  1 as no,
                translate(dbms_lob.substr(a.sql_fulltext,3800,1),':','&') as SQL_1,
                'Hash-Value : '||hash_value as hash_value
        from    v$sql a
        where   0=0
        and     a.sql_text like '%'||'&TEXT'||'%'
        union all
        select  2 as no,
                translate(dbms_lob.substr(a.sql_fulltext,5000,3801),':','&') as SQL_1,
                'Hash-Value : '||hash_value as hash_value
        from    v$sql a
        where   0=0
        and     a.sql_text like '%'||'&TEXT'||'%'
        )
order by no
/
