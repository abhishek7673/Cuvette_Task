
-- 1. Top 5 Customers by Total Purchase Amount
SELECT TOP 5
    c.FirstName + ' ' + c.LastName AS CustomerName,
    SUM(i.Total) AS TotalSpent
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY TotalSpent DESC;

-- 2. Most Popular Genre by Total Tracks Sold
SELECT TOP 1
    g.Name AS Genre,
    COUNT(il.InvoiceLineId) AS TotalTracksSold
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY TotalTracksSold DESC;

-- 3. Employees Who Are Managers and Their Subordinates
SELECT 
    mgr.FirstName + ' ' + mgr.LastName AS ManagerName,
    emp.FirstName + ' ' + emp.LastName AS SubordinateName
FROM Employee emp
JOIN Employee mgr ON emp.ReportsTo = mgr.EmployeeId;

-- 4. Most Sold Album per Artist
WITH AlbumSales AS (
    SELECT 
        a.ArtistId,
        a.Name AS ArtistName,
        al.AlbumId,
        al.Title AS AlbumTitle,
        COUNT(il.InvoiceLineId) AS TotalSold
    FROM Artist a
    JOIN Album al ON a.ArtistId = al.ArtistId
    JOIN Track t ON al.AlbumId = t.AlbumId
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    GROUP BY a.ArtistId, a.Name, al.AlbumId, al.Title
),
RankedAlbums AS (
    SELECT *,
           RANK() OVER (PARTITION BY ArtistId ORDER BY TotalSold DESC) AS AlbumRank
    FROM AlbumSales
)
SELECT 
    ArtistId,
    ArtistName,
    AlbumTitle,
    TotalSold
FROM RankedAlbums
WHERE AlbumRank = 1;

-- 5. Monthly Sales Trends in 2023 (update year based on your data)
SELECT 
    FORMAT(InvoiceDate, 'yyyy-MM') AS Month,
    SUM(Total) AS MonthlySales
FROM Invoice
WHERE YEAR(InvoiceDate) = 2013
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY Month;
