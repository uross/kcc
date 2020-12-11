prompt input owner
accept owner
prompt input tablename
accept table

select segment_name , blocks from dba_segments
where owner = upper('&owner')
and segment_name = upper('&table');
