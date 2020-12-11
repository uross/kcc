---###############################################################################################################################
--#####  filename : fulltext.sql
--#####  . . . : ...
--#####  . . . : 2010/10/29
--#####  .    . : Top SQL. .... ... .. SQL. .. hash_value. ....
--#####             SQL FULL TEXT. ... STAT... . . ...
--#####  .... : ... => ..... SQL. hash_value. ..
--###############################################################################################################################

set feedback off
set pagesize 900
set heading on
set verify off
set line 160
col Full_SQL format a160
prompt 'input hash value : '
accept hash_value1
col hash_value new_value hash_value

select &hash_value1 hash_value from dual;

select   dbms_lob.substr(a.sql_fulltext,3000,1) as "Full_SQL"
from    v$sqlarea a
--where buffer_gets >100000
where hash_value = &hash_value
union all
select   dbms_lob.substr(a.sql_fulltext,6001,3001) as "Full_SQL"
from    v$sqlarea a
--where buffer_gets >100000
where hash_value = &hash_value
UNION ALL
SELECT
        'buffer get (avg)     = '||to_char(round(buffer_gets/decode(executions,0,1,executions),2),'999,999,999,990.99')  as "Buffer Get(avg)"
from    v$sqlarea a
--where buffer_gets >100000
where hash_value = &hash_value
UNION ALL
SELECT
        'buffer get           = '||to_char(buffer_gets,'999,999,999,990.99')
from    v$sqlarea a
--where buffer_gets >100000
where hash_value = &hash_value
UNION ALL
SELECT
        'Executions           = '||to_char(executions, '999,999,999,990.99')
from    v$sqlarea a
--where buffer_gets >100000
where hash_value = &hash_value
union all
select 'Elpsed Time          = '|| to_char(round(elapsed_time / decode(executions,0,1,executions)/1000000,3),'999,999,999,990.99')  as "Elapsed Time(Sec)"
from v$sqlarea a
where hash_value = &hash_value
union all
select
       'Day Buffer Get(avg)  = ' || to_char(round(buffer_gets / decode(round(sysdate-to_date(first_load_time,'yyyy-mm-dd/hh24:mi:ss')),0,1,round(sysdate-to_date(first_load_time,'yyyy-mm-dd/hh24:mi:ss'))),2),'999,999,999,990.99')
 from v$sqlarea  a
 where hash_value = &hash_value
union all
select
       'Day Execution(avg)   = ' || to_char(round(executions / decode(round(sysdate-to_date(first_load_time,'yyyy-mm-dd/hh24:mi:ss')),0,1,round(sysdate-to_date(first_load_time,'yyyy-mm-dd/hh24:mi:ss'))),2),'999,999,999,990.99')
 from v$sqlarea  a
  where hash_value = &hash_value
union all
SELECT 'Day Buffer Get(Per)  = ' || to_char ( (
        SELECT ROUND( buffer_gets /decode( ROUND( sysdate- TO_DATE( first_load_time , 'yyyy-mm-dd/hh24:mi:ss' ) ) , 0 , 1 , ROUND( sysdate- TO_DATE( first_load_time , 'yyyy-mm-dd/hh24:mi:ss' )) , 2 ))
        FROM   v$sqlarea
        WHERE  hash_value=&hash_value
       ) /round( (
                  SELECT VALUE
                  FROM   v$sysstat
                  WHERE  stat_id='3143187968'
                 ) /round( (SYSDATE - startup_time) / (6/7) ) ) *100 ,'999,999,999,990.999') || '%'
FROM   v$instance;
;
