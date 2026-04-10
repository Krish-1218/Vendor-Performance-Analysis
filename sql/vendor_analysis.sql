
-- View Raw Data
SELECT * FROM sales;

-- Revenue by Brand
SELECT 
    brand,
    SUM(salesdollars) AS revenue
FROM sales
GROUP BY brand;

-- Sales + Purchases Join
SELECT 
    s.inventoryid,
    s.brand,
    s.salesquantity,
    s.salesdollars,
    p.purchaseprice
FROM sales s
LEFT JOIN purchases p
ON s.inventoryid = p.inventoryid
AND s.vendornumber = p.vendornumber;

-- KPI Calculation (Revenue, Cost, Profit)
SELECT 
    s.brand,
    SUM(s.salesdollars) AS revenue,
    SUM(p.purchaseprice * s.salesquantity) AS cost,
    SUM(s.salesdollars - (p.purchaseprice * s.salesquantity)) AS profit
FROM sales s
LEFT JOIN purchases p
ON s.inventoryid = p.inventoryid
GROUP BY s.brand;

-- Profit Margin Analysis
SELECT 
    s.brand,
    SUM(s.salesdollars) AS revenue,
    SUM(p.purchaseprice * s.salesquantity) AS cost,
    SUM(s.salesdollars - (p.purchaseprice * s.salesquantity)) AS profit,
    SUM(s.salesdollars - (p.purchaseprice * s.salesquantity)) 
    / NULLIF(SUM(s.salesdollars), 0) AS profit_margin
FROM sales s
LEFT JOIN purchases p
ON s.inventoryid = p.inventoryid
GROUP BY s.brand;

-- Top Vendors by Revenue
SELECT 
    s.vendornumber,
    SUM(s.salesdollars) AS revenue
FROM sales s
GROUP BY s.vendornumber
ORDER BY revenue DESC
LIMIT 10;

-- Lowest Profit Products
SELECT 
    s.inventoryid,
    SUM(s.salesdollars - (p.purchaseprice * s.salesquantity)) AS profit
FROM sales s
LEFT JOIN purchases p
ON s.inventoryid = p.inventoryid
GROUP BY s.inventoryid
ORDER BY profit ASC
LIMIT 10;

-- Inventory Turnover Analysis
SELECT 
    s.inventoryid,
    SUM(s.salesquantity) /
    NULLIF(AVG((b.onhand + e.onhand) / 2), 0) AS inventory_turnover
FROM sales s
LEFT JOIN begin_inventory b
ON s.inventoryid = b.inventoryid
LEFT JOIN end_inventory e
ON s.inventoryid = e.inventoryid
GROUP BY s.inventoryid;

-- Vendor Performance Summary
SELECT 
    s.vendornumber,
    SUM(s.salesdollars) AS revenue,
    SUM(p.purchaseprice * s.salesquantity) AS cost,
    SUM(s.salesdollars - (p.purchaseprice * s.salesquantity)) AS profit
FROM sales s
LEFT JOIN purchases p
ON s.inventoryid = p.inventoryid
GROUP BY s.vendornumber
ORDER BY profit DESC;