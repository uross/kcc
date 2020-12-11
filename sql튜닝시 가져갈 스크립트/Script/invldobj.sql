select  'ALTER '||decode(a.object_type, 'PACKAGE BODY', 'PACKAGE', a.object_type) ||' OMPDBA.'||a.object_name||' compile ;'
from    dba_objects a
where   a.object_type in ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY', 'TRIGGER', 'VIEW')
and     a.status = 'INVALID'
and     a.owner = 'OMPDBA'
/
