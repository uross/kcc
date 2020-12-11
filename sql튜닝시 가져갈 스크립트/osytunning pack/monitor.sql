select 'active : ', count(*) from v$session where status='ACTIVE'
union all
select 'lock : ', count(*) from v$session  where lockwait is not null  ;
