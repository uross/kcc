set lines 10000 pages 10000
select  decode(a.line,1,chr(10)||chr(10)||
                          '/************************************/'||
                          chr(10)||a.text||
                          '/************************************/'
                          ,replace(a.text,chr(10),'')) text
from    dba_source a
where   0=0
and     a.owner = 'OMPDBA'
and     a.name = upper('&NAME')
order by  a.owner,
          a.name,
          a.type,
          a.line
/
~
