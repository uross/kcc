--###############################################################################################################################
--#####  filename : trc.sql
--#####  . . . : ...
--#####  . . . : 2010/10/29
--#####  .    . : 1.sql .. ... ... .. 10053 Trace. .... ... .. ....
--#####  .... : ...
--###############################################################################################################################


set term on

col value new_value dump

col value2 new_value dump2

select value||'/'||(select lower(instance_name) from v$instance)||'_ora_'||(select spid
                         from v$process
                        where addr=(select paddr
                                      from v$session
                                     where sid =(select sid
                                                   from v$mystat
                                                  where rownum =1)))||'.trc' value, value value2 from v$parameter where name = 'user_dump_dest';

alter session set events '10053 trace name context forever, level 1';


@1.sql


alter session set events '10053 trace name context off';



!vi &dump

set term on

