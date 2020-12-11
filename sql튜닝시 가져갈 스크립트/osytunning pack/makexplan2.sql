--###############################################################################################################################
--#####  filename : makeplan2.sql
--#####  . . . : ...
--#####  . . . : 2010/10/29
--#####  .    . : Full Text. Runtime Plan. ... SQL. .. V$SQL_BIND_CAPTURE. ...
--#####             .. Xplan. ... . ... Bind .. .... .. Xplan. ..... (10G.. ..)
--#####             .. ..... .... .. ... 10g... .... 1.sql. .. ... ..
--#####             Trace. .... trc..... .... .....
--#####             bind.. :1, :2, :3 .... ... ... .. ... ... . ... :b1.. .... makexplan.sql. .....
--#####  .... : ...
--###############################################################################################################################

set feedback off
set linesize 460
set pagesize 300
col text format 460
set heading off
set verify off
spool 1.sql

--- ... .. :1, :2, :3 .... ...  Trace ..
SELECT 'var b'|| SUBSTR( name , 2 )  || ' ' || datatype_string-
FROM   v$sql_bind_capture
WHERE  hash_value = &hash_value
union all
SELECT 'exec :b'|| SUBSTR( name , 2 ) || ' := ' || decode( datatype , 1 , '''' || value_string || '''' , 2 , value_string )
FROM   v$sql_bind_capture
WHERE  hash_value = &hash_value
union all
select replace(text, ':', ':b') text from (
SELECT
       CASE WHEN INSTR( a , '/*+' ) =0 OR  INSTR( a , '/*+' ) >= 20
           THEN 'select /*+ GATHER_PLAN_STATISTICS */ ' || SUBSTR( a , INSTR( LOWER( a ) , 'select' ) +6 )
           ELSE 'SELECT ' ||substr( a , INSTR( LOWER( a ) , 'select' ) +6 , INSTR( a , '*/' ) - INSTR( LOWER( a ) , 'select' ) - 6 ) || ' GATHER_PLAN_STATTICS ' || SUBSTR( a , INSTR( a , '*/' )  )
       END text
FROM   (
            select   dbms_lob.substr(a.sql_fulltext,dbms_lob.getlength(a.sql_fulltext),1)||';' as a
              from    v$sqlarea a
           --where buffer_gets >100000
             where hash_value = &hash_value
       )
);

spool off
set heading on
set verify on

--@xplan

