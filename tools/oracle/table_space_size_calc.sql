-- Oracle•\—ÌˆæŒvŽZ

set lines 120
set pages 100
set term off
tti off
clear col
col TABLESPACE_NAME     format a15
col "SIZE(KB)"          format a20
col "USED(KB)"          format a20
col "FREE(KB)"          format a20
col "USED(%)"           format 990.99
select
  tablespace_name,
  to_char(nvl(total_bytes / 1024,0),'999,999,999') as "size(KB)",
  to_char(nvl((total_bytes - free_total_bytes) / 1024,0),'999,999,999') as "used(KB)",
  to_char(nvl(free_total_bytes/1024,0),'999,999,999') as "free(KB)",
  round(nvl((total_bytes - free_total_bytes) / total_bytes * 100,100),2) as "rate(%)"
from
  ( select
      tablespace_name,
      sum(bytes) total_bytes
    from
      dba_data_files
    group by
      tablespace_name
  ),
  ( select
      tablespace_name free_tablespace_name,
      sum(bytes) free_total_bytes
    from
      dba_free_space
    group by tablespace_name
  )
where
  tablespace_name = free_tablespace_name(+)
/