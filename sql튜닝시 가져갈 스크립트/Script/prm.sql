select  'DEFINE '||
        replace(a.name,':','')||' = '||
        case when a.value_string is null then 'NULL'
             when substr(a.datatype_string,1,3) in ('VAR','CHA') and a.value_string is not null
                  then ''''||a.value_string||''''
             when substr(a.datatype_string,1,3) in ('NUM') and a.value_string is not null
                  then a.value_string
        end datatype_string
from    v$sql_bind_capture a
where   a.hash_value = &hash_value
/
