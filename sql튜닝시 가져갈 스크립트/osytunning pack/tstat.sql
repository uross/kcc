-- STAT.sql
-- .  . : Table ..
-- ... : ...
-- ... : 2002. 1.

set verify off
set timing off
set feedback off
set linesize 300
set pagesize 10000
set serveroutput on
set recsep off
accept schname prompt 'Enter schema name : '
accept tname   prompt 'Enter table name  : '
col column_name format a30
col data_type format a10
col lv format a18
col hv format a18
col dpds heading "PREC|SCALE" format a4
col data_length heading "DATA|LEN" format 9999
col num_buckets heading "NUMBER|BUCKET" format 9999
col num_distinct heading "NUMBER|DISTINCT" format 999999999
col pctfu format a5
col free format a5
col pct format 999
col density  format 0.999999999


col tab_info heading "TABLE NAME|TABLESPACE NAME" FORMAT A35
col degree heading "DEG|REE"              format a3
col blk_info heading "BLOCKS|EMP.B"       format a9
col avg_row_len heading "AVG|ROW|LEN"     format 9999
col avg_space heading "AVG|SPACE"         format 9999
col chain_cnt heading "CHAIN|CNT"         format 9999
col inext heading "Inital/|Next/|MIN/MAX" format a10
col tran heading "INITRAN|MAXTRAN"        format a7
col pct heading "PCTFREE|PCTUSED|PCTINCR" format a9
col free heading "FLst/|FGrp"             format a5

select
  table_name||'('||owner||')' || chr(10) ||tablespace_name||decode(partitioned,'YES','* Partitioned ','')||decode(temporary,'Y','* Temporary ','')  as "TAB_INFO"
, trunc(num_rows) num_rows
, avg_row_len
, blocks || chr(10) || empty_blocks as "BLK_INFO"
, trim(degree) degree
, avg_space
, chain_cnt
, pct_free || '/' || pct_used || '/' || pct_increase pct
, ini_trans || '/' ||max_trans tran
, decode(sign(floor(initial_extent/1024/1024)),1,round(initial_extent/1024/1024)||'m',round(initial_extent/1024)||'k') || '/' ||
  decode(sign(floor(next_extent/1024/1024))   ,1,round(next_extent/1024/1024)   ||'m',round(next_extent/1024)||'k')    || chr(10) ||
  min_extents ||'/'|| decode(max_extents,2147483645,'Unlimit',max_extents) inext
, freelists || '/' || freelist_groups free
, to_char(last_analyzed,'yyyy-mm-dd')  last_anal
from all_tables
where table_name  = upper(trim('&tname'))
  and owner       = upper(trim('&schname'))
union all
select
  table_name || ':' || partition_name ||chr(10) || tablespace_name as "TAB_INFO"
, trunc(num_rows) num_rows
, avg_row_len
, blocks || chr(10) || empty_blocks as "BLK_INFO"
, (select trim(degree) degree from all_tables where table_name=trim(upper('&&tname')))
, avg_space
, chain_cnt
, pct_free || '/' || pct_used || '/' || pct_increase pct
, ini_trans || '/' ||max_trans tran
, decode(sign(floor(initial_extent/1024/1024)),1,round(initial_extent/1024/1024)||'m',round(initial_extent/1024)||'k') || '/' ||
  decode(sign(floor(next_extent/1024/1024))   ,1,round(next_extent/1024/1024)||'m'   ,round(next_extent/1024)||'k')    || chr(10) ||
  min_extent ||'/'|| decode(max_extent,2147483645,'Unlimit',max_extent) inext
, freelists || '/' || freelist_groups free
, to_char(last_analyzed,'yyyy-mm-dd')  last_anal
from all_tab_partitions
where table_name = upper(trim('&tname'))
  and table_owner = upper(trim('&schname'))
order by "TAB_INFO"
;
col index_name  format a32
col u format a1
col tablespace format a10
col num_rows_distinct heading "NUM_ROWS|DISTINCT" format a12
col alb_adb heading "ALB/ADB" format a10
col clustering_factor heading "CLUSTERING|FACTOR"
col blk_info heading "LEAF_BLK|BLEVEL" format a8

select
         index_name||'('||owner||')' index_name
      ,  substr(uniqueness,1,1) u
      , tablespace_name||decode(partitioned,'YES','*Partitioned ','')||decode(temporary,'Y','*Temporary ','') tablespace
      , to_char(trunc(num_rows))||chr(10)||to_char(distinct_keys) as "NUM_ROWS_DISTINCT"
      , clustering_factor
      , leaf_blocks || chr(10) || blevel as "BLK_INFO"
      , avg_leaf_blocks_per_key || '/' ||avg_data_blocks_per_key alb_adb
      , ini_trans || '/' ||max_trans tran
      , decode(sign(floor(initial_extent/1024/1024)),1,round(initial_extent/1024/1024)||'m',round(initial_extent/1024)||'k') || '/' ||
        decode(sign(floor(next_extent/1024/1024)),1,round(next_extent/1024/1024)||'m',round(next_extent/1024)||'k') || chr(10) || min_extents ||'/'|| decode(max_extents,2147483645,'unlimit',max_extents) inext
      , freelists || '/' || freelist_groups free
      , to_char(last_analyzed,'yyyy-mm-dd')  last_anal
from all_indexes
where table_name  = upper(trim('&tname'))
  and table_owner = upper(trim('&schname'))
union all
select /*+ ordered */
         ai.index_name || ':' || aip.partition_name  index_name
      ,  substr(ai.uniqueness,1,1) u
      , aip.tablespace_name||decode(temporary,'Y','*Temporary ','') tablespace
      , to_char(trunc(aip.num_rows))||chr(10)||to_char(aip.distinct_keys) as "NUM_ROWS_DISTINCT"
      , aip.clustering_factor
      , aip.leaf_blocks || chr(10) || aip.blevel as "BLK_INFO"
      , aip.avg_leaf_blocks_per_key || '/' ||aip.avg_data_blocks_per_key alb_adb
      , aip.ini_trans || '/' ||aip.max_trans tran
      , decode(sign(floor(aip.initial_extent/1024/1024)),1,round(aip.initial_extent/1024/1024)||'m',round(aip.initial_extent/1024)||'k') || '/' ||
        decode(sign(floor(aip.next_extent/1024/1024)),1,round(aip.next_extent/1024/1024)||'m',round(aip.next_extent/1024)||'k') || chr(10) || aip.min_extent ||'/'|| decode(aip.max_extent,2147483645,'Unlimit',max_extent) inext
      , aip.freelists || '/' || aip.freelist_groups free
      , to_char(last_analyzed,'yyyy-mm-dd')  last_anal
from
        (select degree,uniqueness,owner,index_name,tablespace_name,partitioned, temporary
         from all_indexes where table_name=upper(trim('&tname')) and table_owner=upper(trim('&schname')) and tablespace_name is null) ai
        ,all_ind_partitions aip
where
  ai.index_name=aip.index_name
  and ai.owner=aip.index_owner
order by index_name ;

col     index_name              format  a32
col     type          format    a4
col     u             format    a1
col column_list  heading "COLUMN LIST" format  a100

select  index_name, substr(index_type,1,4) type, substr(uniqueness,1,1) u,
         ( select   MAX(DECODE(column_position, 1, column_name)) || decode(MAX(DECODE(column_position, 2, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position, 2, column_name)) || decode(MAX(DECODE(column_position, 3, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position, 3, column_name)) || decode(MAX(DECODE(column_position, 4, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position, 4, column_name)) || decode(MAX(DECODE(column_position, 5, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position, 5, column_name)) || decode(MAX(DECODE(column_position, 6, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position, 6, column_name)) || decode(MAX(DECODE(column_position, 7, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position, 7, column_name)) || decode(MAX(DECODE(column_position, 8, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position, 8, column_name)) || decode(MAX(DECODE(column_position, 9, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position, 9, column_name)) || decode(MAX(DECODE(column_position,10, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position,10, column_name)) || decode(MAX(DECODE(column_position,11, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position,11, column_name)) || decode(MAX(DECODE(column_position,12, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position,12, column_name)) || decode(MAX(DECODE(column_position,13, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position,13, column_name)) || decode(MAX(DECODE(column_position,14, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position,14, column_name)) || decode(MAX(DECODE(column_position,15, column_name)), null, null, ', ') ||
            MAX(DECODE(column_position,15, column_name)  )
     from  all_ind_columns   col
   where   col.index_name  = a.index_name
     and   col.table_owner = a.table_owner
     and   col.table_name  = a.table_name )  as column_list
from all_indexes     a
                where a.table_name  = upper(trim('&tname'))
                  and a.table_owner = upper(trim('&schname'))
order by index_name;



set heading  off
select '          ' from dual ;

declare

v_col_list varchar2(255);
v_partitioned varchar2(3);

cursor cur_col is
        select column_name
        from ALL_PART_KEY_COLUMNS
        where owner = upper(trim('&schname'))
        and name = upper(trim('&tname'))
        order by column_position;
begin

        select partitioned into v_partitioned
        from all_tables
        where owner = upper(trim('&schname'))
        and table_name = upper(trim('&tname'));

        if v_partitioned = 'YES' then
                for j in cur_col loop
                        v_col_list := v_col_list || j.column_name ||', ';
                end loop;

                v_col_list := substr(v_col_list,1,length(v_col_list) -2);

                dbms_output.put_line('Partition Column(s) : ' || v_col_list);
        end if;

end;
/



set heading  on
set verify   on
set timing   on
set feedback on
set serveroutput off
set head on
set linesize 100
