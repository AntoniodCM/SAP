select a.connection_status, a.connection_id, b.statement_id, a.user_name, a.workload_class_name, cast (sum(b.used_memory_size /(1024*1024*1024)) as decimal (10,3)) as Memoria_usada_GB
from m_connections a, m_active_statements b
where a.connection_id = b.connection_id and
      b.used_memory_size/(1024*1024*1024) >= '0.005' -- Mínimo 5MB --and
      --a.connection_status = 'RUNNING' and
      --a.workload_class_name like '%' and
      --a.workload_class_name <> '_SYS_DEFAULT'
group by  a.connection_status, a.connection_id, a.user_name, a.workload_class_name, b.statement_id
order by a.workload_class_name asc,
         Memoria_usada_GB desc;
