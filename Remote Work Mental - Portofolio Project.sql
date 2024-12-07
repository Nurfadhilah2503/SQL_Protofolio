use project_remote_mental_health;

SELECT * FROM impact_of_remote_work_on_mental_health;

desc impact_of_remote_work_on_mental_health;

SHOW CREATE TABLE impact_of_remote_work_on_mental_health;

# Persentage of Stress Level

SELECT 
    Stress_Level,
    COUNT(*) AS Total_Employees,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM  impact_of_remote_work_on_mental_health)), 2) AS Percentage
FROM 
	impact_of_remote_work_on_mental_health
GROUP BY 
    Stress_Level
ORDER BY 
    Percentage DESC;



# Total Employees in the industry in each job role

SELECT 
    Job_Role,
    Industry,
    COUNT(*) AS Total_Employees
FROM 
    impact_of_remote_work_on_mental_health
GROUP BY 
    Job_Role, Industry
ORDER BY 
    Job_Role, Total_Employees DESC;


# Working Hours vs Stress Levels

SELECT Stress_Level, AVG(Hours_Worked_Per_Week) AS Avg_Hours
FROM impact_of_remote_work_on_mental_health
GROUP BY Stress_Level;


# Work Location Distribution

SELECT Work_Location, COUNT(*) AS Employee_Count
FROM impact_of_remote_work_on_mental_health
GROUP BY Work_Location;


# Region Location Distribution

SELECT Region, COUNT(*) AS Region_Count
FROM impact_of_remote_work_on_mental_health
GROUP BY Region;


# Total Work Location each Region Location Distribution

SELECT 
    Region,
    Work_Location,
    COUNT(*) AS Total_Employees
FROM 
    impact_of_remote_work_on_mental_health
GROUP BY 
    Region, Work_Location
ORDER BY 
    Region, Total_Employees DESC;


# Job Satisfaction by work location 

SELECT 
    Work_Location,
    Satisfaction_with_Remote_Work,
    COUNT(*) AS Total_Employees,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Work_Location)), 2) AS Percentage
FROM 
    impact_of_remote_work_on_mental_health
GROUP BY 
    Work_Location, Satisfaction_with_Remote_Work
ORDER BY 
    Work_Location, Percentage DESC;


# The impact of mental health on productivity

SELECT 
    Mental_Health_Condition,
    Productivity_Change,
    COUNT(*) AS Total_Employees,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM impact_of_remote_work_on_mental_health)), 2) AS Percentage
FROM 
    impact_of_remote_work_on_mental_health
GROUP BY 
    Mental_Health_Condition, Productivity_Change
ORDER BY 
    Mental_Health_Condition, Percentage DESC;
