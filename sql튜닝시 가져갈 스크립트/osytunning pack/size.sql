select 'TABLE', segment_name, lpad(sum(bytes)/1024/1024,10) || 'M' from dba_segments where owner='OMPDBA' and segment_name=upper('&1') group by segment_name
union all
select 'INDEX',  segment_name, lpad(sum(bytes)/1024/1024,10) || 'M' from dba_segments where owner='OMPDBA' and segment_name in (
select index_name from dba_indexes where owner='OMPDBA' and table_name=upper('&1'))  group by segment_name       ;
