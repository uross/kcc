--###############################################################################################################################
--#####  filename : maketrc.sql
--#####  . . . : ...
--#####  . . . : 2010/10/29
--#####  .    . : Full Text. Runtime Plan. ... SQL. .. V$SQL_BIND_CAPTURE. ...
--#####             .. Trace. ... . ... Bind .. .... .. Trace. ..... (10G.. ..)
--#####             .. ..... .... .. ... 10g... .... 1.sql. .. ... ..
--#####             Trace. .... trc..... .... .....
--#####             bind.. :1, :2, :3 .... ... ... .. ... ... . ... :b1.. .... maketrc.sql. .....
--#####  .... : ...
--###############################################################################################################################

set feedback off
set linesize 170
set pagesize 300
col text format 80
set heading off
set verify off

spool 1.sql

--- ... .. :1, :2, :3 .... ...  Trace ..

SELECT 'var b'|| SUBSTR( name , 2 )  || ' ' || datatype_string text
FROM   v$sql_bind_capture
WHERE  hash_value = &hash_value
union all
SELECT 'exec :b'|| SUBSTR( name , 2 ) || ' := ' || decode( datatype , 1 , '''' || value_string || '''' , 2 , value_string )
FROM   v$sql_bind_capture
WHERE  hash_value = &hash_value
union all
select replace(a, ':', ':b') from (
select   dbms_lob.substr(a.sql_fulltext,dbms_lob.getlength(a.sql_fulltext),1) ||';' a
from    v$sqlarea a
WHERE  hash_value = &hash_value )
;

spool off
set heading on
set verify on


@trc

