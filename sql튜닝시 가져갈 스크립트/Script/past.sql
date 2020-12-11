select  substr(a.sql_text,1,100) sqltxt,
        a.executions,
        a.hash_value,
        to_char(to_date(a.first_load_time, 'yyyy-mm-dd/hh24:mi:ss'), 'yyyy/mm/dd hh24:mi:ss') as start_time,
        round((a.elapsed_time/1000000)/decode(a.executions,0,1,a.executions),5) as "ELS_TIME(sec)"
from    v$sql a
where   0=0
and     to_char(to_date(a.first_load_time,'yyyy-mm-dd hh24:mi:ss'),'yyyymmdd hh24:mi:ss') >= '&YYYYMMDD '||'&HH24:MI:SS'
--and     to_char(to_date(a.first_load_time,'yyyy-mm-dd hh24:mi:ss'),'yyyymmdd hh24:mi:ss') between '20100525 13:40:00' and '20100525 13:50:00'
and     upper(a.sql_text) not like '%BEGIN%'
and     upper(a.sql_text) not like '%SQLAREA%'
and     upper(a.sql_text) not like '%DBA_%'
and     upper(a.sql_text) not like '%USER_%'
and     upper(a.sql_text) not like '%ALL_%'
and     upper(a.sql_text) not like '%TS_MAILQUEUE%'
order by 5 desc
/
