SELECT
    t.transaction_id,
    t.date,
    b.branch_id,
    b.branch_name,
    b.kota,
    b.provinsi,
    b.rating AS branch_rating,
    t.customer_name,
    p.product_id,
    p.product_name,
    p.price,
    t.discount_percentage,
    CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,
    (p.price - (p.price * t.discount_percentage / 100)) AS nett_sales,
    ((p.price - (p.price * t.discount_percentage / 100)) *
    CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        ELSE 0.30
    END) AS nett_profit,
    t.rating AS transaction_rating
FROM Kimia_Farma.KF_Transactions t
LEFT JOIN Kimia_Farma.KF_Products p ON t.product_id = p.product_id
LEFT JOIN Kimia_Farma.KF_Branches b ON t.branch_id = b.branch_id
