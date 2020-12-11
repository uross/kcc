--###############################################################################################################################
--#####  filename : trc.sql
--#####  . . . : ...
--#####  . . . : 2010/10/29
--#####  .    . : 1.sql .. ... ... .. Trace. ......
--#####  .... : ...
--###############################################################################################################################

@ch

set term off

col value new_value dump

col value2 new_value dump2

select value||'/'||(select lower(instance_name) from v$instance)||'_ora_'||(select spid
                         from v$process
                        where addr=(select paddr
                                      from v$session
                                     where sid =(select sid
                                                   from v$mystat
                                                  where rownum =1)))||'.trc' value, value value2 from v$parameter where name = 'user_dump_dest';


alter session set events '10046 trace name context forever,level 4';


alter session set "_rowsource_execution_statistics"=true;

@1.sql

select * from dual;


alter session set events '10046 trace name context off';


! tkprof &dump /maxgauge/osy/osy.txt sort=fchela

! vi /maxgauge/osy/osy.txt

set term on