-- TOTAL NUMBER OF VACINATED POPULATION PARTITION BY COUNTRY AND DATE-- 
SELECT cd.continent , cd.location , cd.date , cd.population , cv.new_vaccinations, 
SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS total_vaci
FROM coviddeaths cd
JOIN covidvacinated cv 
ON cd.location = cv.location 
WHERE cd.continent IS NOT NULL
AND cd.date = cv.date
ORDER BY 2,3;

-- PERCENTAGE OF POPULATION VACINATED SPERATED BY COUNTRY--

WITH popvsvac AS 
(
	SELECT cd.continent , cd.location , cd.date , cd.population , cv.new_vaccinations, 
	SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS total_vaci
	FROM coviddeaths cd
	JOIN covidvacinated cv 
	ON cd.location = cv.location 
	WHERE cd.continent IS NOT NULL
	AND cd.date = cv.date
)

SELECT *, (total_vaci/population)*100 AS percentage_of_pop_vacinated
FROM popvsvac


-- PERCENTAGE OF POPULATION VACINATED SPERATED BY COUNTRY-- SECOND METHOD
DROP TABLE IF EXISTS #percentageofpopvacinated
CREATE TABLE #percentageofpopvacinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population NUMERIC,
new_vaccinations NUMERIC,
total_vaci NUMERIC
)

INSERT INTO #percentageofpopvacinated
	SELECT cd.continent , cd.location , cd.date , cd.population , cv.new_vaccinations, 
	SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS total_vaci
	FROM coviddeaths cd
	JOIN covidvacinated cv 
	ON cd.location = cv.location 
	AND cd.date = cv.date


SELECT *, (total_vaci/population)*100 AS percentage_of_pop_vacinated
FROM #percentageofpopvacinated

-- Creating Views for Later Visualizations --
CREATE VIEW percentageofpopvacinated AS 
	SELECT cd.continent , cd.location , cd.date , cd.population , cv.new_vaccinations, 
	SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS total_vaci
	FROM coviddeaths cd
	JOIN covidvacinated cv 
	ON cd.location = cv.location 
	AND cd.date = cv.date
	WHERE cd.continent IS NOT NULL



