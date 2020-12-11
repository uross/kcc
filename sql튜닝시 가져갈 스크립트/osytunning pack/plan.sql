--###############################################################################################################################
--#####  filename : plan.sql
--#####  . . . : ...
--#####  . . . : 2010/10/29
--#####  .    . : Top SQL. ... SQL. .. Runtime Plan. .. ...
--#####  .... : ...
--###############################################################################################################################


set heading off

     select lpad(operation, length(operation)+2*(level-1))||
       decode(id,0, 'Cost Estimate : ' ||  decode (position , '0','N/A',position), null)|| ' ' || options ||  decode(object_name, null, null, ' : ') ||
       object_owner|| case when object_name is not null then '.' else '' end || object_name||
       decode(object_type, 'UNIQUE',' (U)', 'NIN_UNIQUE',
       '(NU)', null)
       || decode(access_predicates, null, null, ' (acccess = ' || access_predicates ||' )' )   -- access predicates ..
       || decode(filter_predicates, null, null, ' (filter = ' || filter_predicates || ' )')    -- filter predicates ..
       plan
  from v$sql_plan
  start with id=0 and hash_value=&hash_value
  connect by prior id=parent_id and hash_value=&hash_value
;

set heading on

