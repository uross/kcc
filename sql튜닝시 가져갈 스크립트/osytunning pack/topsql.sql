--###############################################################################################################################
--#####  filename : topsql.sql
--#####  . . . : ...
--#####  . . . : 2010/10/29
--#####  .    . : V$SQLAREA.. TOPSQL. .. .. .. ....
--##### .... : ... . ==> TOP SQL. ... ....
--#####                          1. Load Time
--#####                          2. Session Logical Reads ..
--#####                          3. Session Logicar Reads ...
--#####                          4. physical reads ..
--#####                          7. ....
--#####                          8. cputime ..
--#####                          9  elapse time ..
--#####            ... . ==> Top .... ... .... ...
--###############################################################################################################################


set verify off
set heading on
set linesize  180
col FIRST_LOAD_TIME format a20
set pagesize 1000

PROMPT ###########################################
PROMPT #            input number                 #
PROMPT ###########################################
PROMPT #            1.load_time                  #
PROMPT #            2.logical_reads              #
PROMPT #            3.logicalreads(avg)          #
PROMPT #            4.physical                   #
PROMPT #            5.execution                  #
PROMPT #            6.cputime                    #
PROMPT #            7.elpasetime                 #
PROMPT #            8.elpasetime(avg)            #
PROMPT ###########################################

accept a
PROMPT input numger : count sotp number
accept b
spool viewtopsql.txt

select a.*, rownum rum  from (
  select first_load_time, buffer_gets
      ,round(buffer_gets/decode(executions,0,1,executions)) buffer_get_avg
      ,disk_reads/decode(executions,0,1,executions) disk_read_avg
      ,EXECUTIONS
      ,CPU_TIME
      ,ELAPSED_TIME
      ,round(elapsed_time / decode(executions,0,1,executions)/1000000,3) elapse_avg
      , hash_value
      ,ROWS_PROCESSED
      ,ROWS_PROCESSED/decode(executions,0,1,executions) row_processed_avg
  from v$sqlarea
where buffer_gets >100
 order by &a desc
)a where rownum <= &b;

spool off
