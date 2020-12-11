col sid new_value psid

select &p1 sid from dual;

select sid, sigio, round(sigio/last_call_et) avgio, last_call_et elapse from (
select (select  value from v$sesstat where sid=&psid and statistic#=10) sigio , last_call_et, sid  from v$session where sid=&psid);
