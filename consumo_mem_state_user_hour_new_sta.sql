SELECT
         max (HOST) "HOST",
         max (PORT) "PORT",
         DB_USER,
         max (MEM_PER_EXEC_GB) "MAYOR_EJECUCION_GB",
         sum (MEM_PER_EXEC_GB) "SUMA_TOTAL_GB",
         count (DISTINCT STATEMENT_ID) "NUM_STATEMENTS",     
         max (HORA) "HORA",
         sum(case when TO_DOUBLE(MEM_PER_EXEC_GB)>='300'                                      then 1 else 0 end) "GB/Stmt >= 300",
         sum(case when TO_DOUBLE(MEM_PER_EXEC_GB)<'300' AND TO_DOUBLE(MEM_PER_EXEC_GB)>='210' then 1 else 0 end) "300 > GB/Stmt >= 210",
         sum(case when TO_DOUBLE(MEM_PER_EXEC_GB)<'210' AND TO_DOUBLE(MEM_PER_EXEC_GB)>='150' then 1 else 0 end) "210 > GB/Stmt >= 150",
         sum(case when TO_DOUBLE(MEM_PER_EXEC_GB)<'150' AND TO_DOUBLE(MEM_PER_EXEC_GB)>='100' then 1 else 0 end) "150 > GB/Stmt >= 100",
         sum(case when TO_DOUBLE(MEM_PER_EXEC_GB)<'100' AND TO_DOUBLE(MEM_PER_EXEC_GB)>='50'  then 1 else 0 end) "100 > GB/Stmt >= 50",
         sum(case when TO_DOUBLE(MEM_PER_EXEC_GB)<'50'  AND TO_DOUBLE(MEM_PER_EXEC_GB)>='25'  then 1 else 0 end) "50 > GB/Stmt >= 25",
         sum(case when TO_DOUBLE(MEM_PER_EXEC_GB)<'25'  AND TO_DOUBLE(MEM_PER_EXEC_GB)>='10'  then 1 else 0 end) "25 > GB/Stmt >= 10",
         sum(case when TO_DOUBLE(MEM_PER_EXEC_GB)<'10'  AND TO_DOUBLE(MEM_PER_EXEC_GB)>='1'   then 1 else 0 end) "10 > GB/Stmt >= 1",
         sum(case when TO_DOUBLE(MEM_PER_EXEC_GB)<'1'                                         then 1 else 0 end) "GB/Stmt < 1"
FROM (
SELECT HOST, PORT, DB_USER, MAX (MEMORY_SIZE/(1024*1024*1024)) AS MEM_PER_EXEC_GB, statement_id, right (concat ('0' , RTRIM(EXTRACT (HOUR FROM (add_seconds (TO_TIMESTAMP (CURRENT_TIMESTAMP), 3600*23) ))) ),2) || ':00:00' AS HORA
FROM M_EXPENSIVE_STATEMENTS
WHERE START_TIME between TO_TIMESTAMP((select right (concat ('0' , RTRIM(EXTRACT (YEAR FROM (CURRENT_DATE))) ) ,4) || '/' || right (concat ('0' , RTRIM(EXTRACT (MONTH FROM (CURRENT_DATE))) ) ,2) || '/' ||  right (concat ('0' , RTRIM(EXTRACT (DAY FROM (CURRENT_DATE))) ),2) || ' ' || right (concat ('0' , RTRIM(EXTRACT (HOUR FROM (add_seconds (TO_TIMESTAMP (CURRENT_TIMESTAMP), 3600*23) ))) ),2) || ':00:00' from dummy),'YYYY/MM/DD HH24:mi:SS') and TO_TIMESTAMP((select right (concat ('0' , RTRIM(EXTRACT (YEAR FROM (CURRENT_DATE))) ) ,4) || '/' || right (concat ('0' , RTRIM(EXTRACT (MONTH FROM (CURRENT_DATE))) ) ,2) || '/' ||right (concat ('0' , RTRIM(EXTRACT (DAY FROM (CURRENT_DATE))) ),2) || ' ' || right (concat ('0' , RTRIM(EXTRACT (HOUR FROM (CURRENT_TIME))) ),2)  || ':00:00' from dummy),'YYYY/MM/DD HH24:mi:SS')
GROUP BY HOST, PORT, DB_USER, STATEMENT_ID
ORDER BY DB_USER
)
group by DB_USER
  ORDER BY DB_USER;
