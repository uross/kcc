SELECT 'var b'|| SUBSTR( name , 2 )  || ' ' || datatype_string text
FROM   v$sql_bind_capture
WHERE  hash_value = &hash_value
union all
SELECT 'exec :b'|| SUBSTR( name , 2 ) || ' := ' || decode( datatype , 1 , '''' || value_string || '''' , 2 , value_string )
FROM   v$sql_bind_capture
WHERE  hash_value = &hash_value
;
