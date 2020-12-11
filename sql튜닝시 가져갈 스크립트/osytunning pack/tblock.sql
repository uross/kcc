
col segment_name format a70
set line  170

select segment_name , blocks from dba_segments where segment_name= upper('&sname');
