select  c.object_name,
        a.sid,
        a.serial#
from    v$session   a,
        v$lock      b,
        dba_objects c
where   0=0
and     a.sid = b.sid
and     b.id1 = c.object_id
and     b.type = 'TM'
and     c.object_name = upper('& Table_Name')
/
