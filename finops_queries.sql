-- Cloud Infrastructure FinOps Audit
-- Objective: Identifying idle (zombie) resources < 5% CPU usage

-- 1. Setup Tables
CREATE OR REPLACE TABLE instances_metadata (instance_id INT, department STRING, cost_per_hour DECIMAL(10, 2));
CREATE OR REPLACE TABLE usage_logs (instance_id INT, cpu_usage_percent DECIMAL(5, 2), timestamp TIMESTAMP);

-- 2. Analysis: Identify Idle Servers
SELECT 
    u.instance_id, 
    m.department, 
    (m.cost_per_hour * 24 * 30) AS potential_monthly_wastage
FROM usage_logs u
JOIN instances_metadata m ON u.instance_id = m.instance_id
WHERE u.cpu_usage_percent < 5.0;

-- 3. Report: Department-wise Wastage
SELECT 
    m.department, 
    SUM(m.cost_per_hour * 24 * 30) AS total_monthly_wastage
FROM usage_logs u
JOIN instances_metadata m ON u.instance_id = m.instance_id
WHERE u.cpu_usage_percent < 5.0
GROUP BY m.department;
