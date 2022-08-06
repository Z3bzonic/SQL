-- 1. Selecteer alle klanten die in Duitsland of Londen wonen. Sorteer oplopend op naam.

SELECT CustomerName FROM Customers
WHERE 
	Country = "Germany" 
OR
	City = "London"
ORDER BY 
	CustomerName ASC;
	
-- 2. Haal alle producten op die minder dan 40$ kosten.
	--Breidt bovenstaande query uit door ook de naam en beschrijving van de productcategorie te tonen.
	--Sorteer op prijs, van duur naar goedkoop.	
	
SELECT ProductName, Price, CategoryName, Description FROM Products
INNER JOIN Categories
	ON Products.CategoryID = Categories.CategoryID
WHERE Price < 40
ORDER BY Price DESC;	

-- 3. Voeg jezelf toe als klant (Adres mag vals zijn)
-- Voeg enkele orders toe op jouw naam.

INSERT INTO Customers
	(CustomerName,ContactName,Address,City,PostalCode,Country)
VALUES
	("Bart Roels","Francine Van Haesendonck", "Roadrunner Lane 333","ACME",1991,"LoonyLand");
	
INSERT INTO Orders (CustomerID,EmployeeID,OrderDate,ShipperID)
VALUES (92,5,"2022-08-05",1);

-- 4. Toon alle klanten die ‘Carlos’ heten.	

SELECT ContactName FROM Customers
WHERE ContactName LIKE "Carlos%";

-- 5. Pas de ShipperName van United Package aan naar United Packages International.
-- 	Zorg ervoor dat enkel 1 record aangepast kan worden.

UPDATE Shippers
SET Shippername = "United Package International"
WHERE ShipperName = "United Package"

-- 6. Haal alle orders op van 1997. Toon ook de CustomerName, ContactName, Country van de klant en de voor-en achternaam van de verkoper, alsook de --SuplierName van de leverancier.
--	De kolom Country is generiek. Een derde partij weet niet of het over het land van de klant, 
--	verkoper of leverancier gaat. Geef deze kolom weer als ‘CustomerCountry’.

SELECT OrderID, OrderDate, CustomerName, ContactName, Country AS CustomerCountry FROM Orders
INNER JOIN Customers
	ON	Orders.CustomerID = Customers.CustomerID
WHERE OrderDate LIKE "1997-%"

-- 7. Toon alle klanten die minstens 1 bestelling geplaatst hebben (Tip: Inner Join)

SELECT DISTINCT CustomerName FROM Customers
INNER JOIN Orders
	ON Customers.CustomerID = Orders.CustomerID

-- 8. Toon alle klanten die nog geen bestellingen geplaatst hebben. (Tip: Outer Join)

SELECT DISTINCT CustomerName, OrderID FROM Customers
LEFT OUTER JOIN Orders
	ON Customers.CustomerID = Orders.CustomerID
WHERE OrderID IS NULL;

-- 9. Haal de top 5 klanten op die de meeste bestellingen geplaatst hebben. Rangschik van hoog naar laag.
-- Filter bovenstaande query door enkel de klanten te tonen met een totaal aantal producten <= 100

SELECT CustomerName, COUNT(Quantity) AS QuantityTotal FROM Customers
INNER JOIN Orders
	ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
WHERE Quantity <= 100
GROUP BY CustomerName
ORDER BY QuantityTotal DESC
LIMIT 5 OFFSET 2

-- 10. Haal de top 3 bestellingen op met het hoogst aantal producten. Toon het ordernummer en het aantal producten in die bestelling. 
-- Noem deze kolom ‘Nr. of Products’.
--	Breidt bovenstaande query uit door ook het land, ID en de naam van de klant weer te geven.
--	Breidt bovenstaande query uit door enkel de bestellingen te tonen die niet in de USA of Oostenrijk plaatsvonden.
--	Filter bovenstaande query door enkel de bestellingen te tonen met een totaal aantal producten <= 150

SELECT o.OrderID, Quantity AS 'Nr. of Products', Country, c.CustomerID, CustomerName FROM Orders o
INNER JOIN OrderDetails d
	ON o.OrderID = d.OrderID
INNER JOIN Customers c
	ON o.CustomerID = c.CustomerID
WHERE NOT Country =  'USA' OR Country = 'AUSTRIA' AND Quantity <= 150
ORDER BY Quantity DESC
LIMIT 3