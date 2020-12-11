SET LINE 200
SET PAGESIZE 300
col ALLOCATE_SIZE format a20
col FREE_SIZE format a20
col REAL_USE_SIZE format a20
col USE_PERCENT format a20

 select a.tablespace_name tablespace_name,
        lpad(round((b.bytes/1024/1024)) || ' MB',13) ALLOCATE_SIZE,
        lpad(round(a.bytes/1024/1024) || ' MB',13) FREE_SIZE,
        lpad(round((b.bytes - a.bytes)/1024/1024) || ' MB',13) REAL_USE_SIZE,
        lpad(round((1-(a.bytes/b.bytes))*100) || ' %',7) USE_PERCENT
   from (select tablespace_name, sum(bytes) bytes from dba_free_space
         group by tablespace_name) a,
         (select tablespace_name, sum(bytes) bytes from dba_data_files
         group by tablespace_name) b  where a.tablespace_name=b.tablespace_name
 union all select '--------------------------', '--------------------', '--------------------', '--------------------', '--------------------' from dual
 union all
 select '(TOTAL : )' ,
        lpad((sum(round((b.bytes/1024/1024))) || ' MB'), 13) USED_SIZE,
        lpad(sum(round(a.bytes/1024/1024)) || ' MB',13) FREE_SIZE,
        lpad(sum(round((b.bytes - a.bytes)/1024/1024)) || ' MB',13) REAL_USE_SIZE,
        lpad(round((1-(sum(a.bytes)/sum(b.bytes)))*100) || ' %',7) USE_PERCENT
   from (select tablespace_name, sum(bytes) bytes from dba_free_space
         group by tablespace_name) a,
         (select tablespace_name, sum(bytes) bytes from dba_data_files
         group by tablespace_name) b  where a.tablespace_name=b.tablespace_name;
