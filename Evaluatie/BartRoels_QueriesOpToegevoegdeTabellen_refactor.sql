USE javadevt_DotNetVlaanderen1;

-- 1. Toon de Brouwers die aan geen enkel cafe leveren.

SELECT b.Id, b.Name FROM Brewers b
LEFT JOIN BarsHasBrewers bh
	ON bh.BrewerId = b.Id
WHERE bh.BrewerId IS NULL;

-- 2. Toon alle cafes die geopend zijn in de voorbije 3 jaar.
-- 2.1 Toon ook de bieren en hun brouwers die hier getapt worden.
-- 2.2 Sla deze informatie op als View

SELECT b.Name AS Barname,OpeningYear, br.Name AS Brewery, be.Name AS 'Tapped Beer' FROM Bars b
LEFT JOIN BarsHasBrewers bh
	ON bh.BarId = b.Id
INNER JOIN Brewers br
	ON bh.BrewerId = br.Id
INNER JOIN Beers be
	ON be.BrewerId =  br.Id
WHERE TIMESTAMPDIFF(Year, OpeningYear, CURRENT_TIMESTAMP) < 3  AND Ontap = TRUE;


-- 3. Toon het aantal eigenaars per cafe.

SELECT COUNT(o.BarId) AS 'Number of Owners', b.Name AS Barname FROM Owners o
INNER JOIN Bars b
	ON b.Id = o.BarId
GROUP BY o.BarId;

-- 4. Geef de namen van alle brouwers die in een stad wonen waar meer dan 2 cafe’s zijn.

SELECT br.Name AS Brewer, COUNT(br.City) AS 'N° of Bars in City', br.City FROM Brewers br
LEFT JOIN Address a
	ON a.City = br.City
WHERE a.City = br.City
GROUP BY br.Name
HAVING COUNT(br.City) > 2;
     
-- 5. Toon alle cafés met mannelijke eigenaars die binnen 5 jaar op pensioen zullen gaan
-- 5.x Hiervoor mag je uitgaan dat de pensioenleeftijd 65 jaar is en ze verjaren op 1 januari

SELECT b.Name AS Barname,o.Name AS 'Owned by', o.Middlename, o.Lastname, 
o.Birthdate, o.Gender FROM Owners o
INNER JOIN Bars b
	ON b.Id = o.BarId
WHERE TIMESTAMPDIFF(Year, Birthdate, CURRENT_TIMESTAMP) > 60 AND Gender = 'M'