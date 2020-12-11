set lines 10000 pages 10000;
col DBNM for a10;
col machine for a30;
col Time for a20;
select  'DB3' as DBNM,
         a.machine,
        to_char(sysdate, 'yyyy/mm/dd hh24:mi:ss') "Time",
        count(*) "Total Sessions",
        count(decode(a.status,'ACTIVE',1)) "Active Sessions"
from    v$session a
where   0=0
and     nvl(a.osuser,'x') <> 'SYSTEM'
and     a.type <> 'BACKGROUND'
group by a.machine
/
