USE javadevt_DotNetVlaanderen1;
-- 1. Welke brouwers hebben een omzet van minstens 140.000?

SELECT Name, Turnover FROM Brewers
WHERE Turnover >= 140000
ORDER BY Turnover DESC;

-- 2. Geef de Id en naam van alle bieren waarbij de naam “fontein” bevat.

SELECT b.Id, b.Name FROM Beers b
WHERE Name LIKE '%Fontein%';

-- 3. Toon de 5 duurste bieren van de brouwer met de meeste omzet

SELECT be.Name, be.Price FROM Beers be
INNER JOIN Brewers br
	ON be.BrewerId = br.Id
WHERE Turnover = (SELECT MAX(Turnover) FROM Brewers)
ORDER BY Price DESC
LIMIT 5;

-- Toon ook de 5 duurste bieren van de brouwer met de minste omzet

SELECT be.Name, be.Price FROM Beers be
INNER JOIN Brewers br
	ON be.BrewerId = br.Id
WHERE Turnover = (SELECT MIN(Turnover) FROM Brewers)
ORDER BY Price DESC
LIMIT 5;

-- 4. Geef de namen van alle brouwers die in Sint-Jans-Molenbeek, Leuven of Antwerpen wonen
-- 	Toon ook de naam en het alcoholpercentage van hun bieren.
--  Sorteer op omzet.

SELECT br.Name,City, be.Name, be.Alcohol FROM Brewers br
INNER JOIN Beers be
	ON  br.Id = be.BrewerId
WHERE City IN ('Sint-Jans-Molenbeek','Leuven','Antwerpen')
ORDER BY Turnover ASC;

-- 5. Geef het aantal bieren per brouwer.
--	Toon ook de naam van de brouwerij.
--	Toon enkel de brouwerijen die meer dan 5 bieren brouwen.
--	Soorteer van hoogste aantal bieren per brouwerij naar het minste.

SELECT br.Name , COUNT(be.Name) AS TotalBeers FROM Brewers br
INNER JOIN Beers be
	ON be.BrewerId = br.Id
GROUP BY br.Name
HAVING TotalBeers > 5
ORDER BY TotalBeers DESC;

-- 6. Toon alle informatie van de bieren met een percentage van minstens 7%.
--	Toon ook alle gerelateerde data.
--	Vermijd duplicate data.
--	Geef bij kolommen met dezelfde namen een duidelijke beschrijving

SELECT DISTINCT be.Name AS Beer, Alcohol AS 'Alcohol %', 
	Price, br.Name AS Brewery, Category  
	FROM Beers be
INNER JOIN Brewers br
	ON br.Id = be.BrewerId
INNER JOIN Categories ca
	ON ca.Id = be.CategoryId
WHERE Alcohol >= 7
ORDER BY Alcohol DESC;

-- 7. Geef de bieren met een alcoholpercentage van meer dan 7 procent van de brouwers die meer dan 65.000 omzet verdienen
-- 	Sorteer op omzet, daarna op alcoholpercentage
-- 	Toon ook de categorie van deze bieren

SELECT be.Name, be.Alcohol, ca.Category, br.Turnover FROM Beers be
INNER JOIN Brewers br 
	ON	br.Id = be.BrewerId
INNER JOIN Categories ca
	ON ca.Id = be.CategoryId
WHERE Turnover > 65000 AND Alcohol > 7
ORDER BY Turnover, Alcohol;

-- 8. Geef het aantal bieren per categorie in een menselijk leesbare vorm.
-- 	Sorteer op naam van de categorie
--	Toon enkel de volgende bieren: Lambik,  AlcolholVrij, Pils, Edelbier, Amber, Light

SELECT ca.Category, COUNT(be.Name) AS 'Aantal Bieren'  FROM Beers be
INNER JOIN Categories ca
	ON ca.Id = be.CategoryId
WHERE Category IN ('Lambik','AlcolholVrij','Pils','Edelbier','Amber','Light')
GROUP BY Category;

-- 9. Toon de bieren die door meer dan 1 brouwerij gebrouwen worden.
-- Toon alle relevante gerelateerde data.
-- Sla dit resultaat op als een View

CREATE VIEW BeersWithMultipleBrewers AS   
SELECT * FROM Beers be
WHERE Name IN (SELECT Name From Beers GROUP BY Name HAVING COUNT(Name) > 1)
ORDER BY Name;

-- 10. Maak een Stored Procedure met 2 input parameters. Laat deze query alle bieren ophalen die aan de volgende parameters voldoen:
-- Een keyword dat voorkomt in de naam van het bier
-- De maximum omzet van de brouwer
-- Het is niet voldoende om enkel de Stored Procedure in je DB te hebben. Toon ook de SQL code die je nodig had voor dit statement te maken.

DELIMITER //
CREATE PROCEDURE GetBeersByNameAndTurnover (IN Search varchar(30), IN Profit int)
BEGIN
	SELECT be.Name, Turnover FROM Beers be
    INNER JOIN Brewers br
		ON br.Id = be.BrewerId
	WHERE be.Name LIKE CONCAT('%',search,'%') AND Turnover >= Profit;
END //
DELIMITER ;

CALL GetBeersByNameAndTurnover('Pils',60000) -- voorbeeld