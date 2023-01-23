-- Fact table
CREATE TABLE orderItem (
  orderItem_id INT PRIMARY KEY,
  order_id INT,
  orderItem_date TEXT,
  product_id INT,
  amount INT,
  branch_id INT,
  staff_id INT
);

-- Dim1 bridge table for multiple product in 1 order
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  FOREIGN KEY (order_id) REFERENCES orderItem(order_id)
);

-- Dim2 customers table
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name TEXT,
  age INT,
  gender TEXT,
  FOREIGN KEY (customer_id) REFERENCES orders(customer_id)
);

-- Dim3 products table
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name TEXT,
  price REAL,
  type TEXT,
  FOREIGN KEY (product_id) REFERENCES orderItem(product_id)
);

-- Dim4 branches table
CREATE TABLE branches (
  branch_id INT PRIMARY KEY,
  location TEXT,
  table_qty INT,
  FOREIGN KEY (branch_id) REFERENCES orderItem(branch_id),
  FOREIGN KEY (branch_id) REFERENCES staffs(branch_id)
);

-- Dim5 staffs table
CREATE TABLE staffs (
  staff_id INT PRIMARY KEY,
  branch_id INT,
  staff_name TEXT,
  salary INT,
  FOREIGN KEY (staff_id) REFERENCES orderItem(staff_id)
);

-- Insert value
INSERT INTO orderItem VALUES
  (1, 1, '2022-08-01', 1, 1, 1, 1),
  (2, 1, '2022-08-01', 2, 2, 1, 1),
  (3, 2, '2022-08-01', 1, 2, 1, 2),
  (4, 3, '2022-08-02', 3, 1, 2, 3),
  (5, 3, '2022-08-02', 4, 1, 2, 3),
  (6, 4, '2022-08-02', 3, 2, 2, 3),
  (7, 4, '2022-08-02', 4, 1, 2, 3),
  (8, 4, '2022-08-02', 5, 1, 2, 3),
  (9, 4, '2022-08-02', 6, 2, 2, 3),
  (10, 5,'2022-08-03', 1, 2, 1, 2);

INSERT INTO orders VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 1);

INSERT INTO products VALUES
  (1, 'Noodle', 80, 'Main' ),
  (2, 'Rice',   20, 'Main' ),
  (3, 'Fried Chichken', 100, 'Main' ),
  (4, 'Pizza', 280, 'Main' ),
  (5, 'Bingzu', 60, 'Dessert' ),
  (6, 'Ice-cream', 40, 'Dessert' );


INSERT INTO customers VALUES
  (1, 'Non',   25, 'Male'),
  (2, 'Jarb',  26, 'Female'),
  (3, 'Man',   30, 'Male'),
  (4, 'New',   18, 'Male');

INSERT INTO branches VALUES
  (1, 'BKK', 5),
  (2, 'LON', 4);

INSERT INTO staffs VALUES
  (1, 1, 'Fluke', 15000),
  (2, 1, 'Tai', 18000),
  (3, 2, 'Best', 21000);

.mode markdown
.header on

-- sample select 
SELECT
  oi.orderItem_id,
  oi.orderItem_date,
  od.order_id,
  cs.customer_name,
  oi.product_id,
  oi.amount,
  pd.product_name,
  pd.price,
  oi.amount * pd.price as total
FROM orderItem as oi
JOIN orders as od on od.order_id = oi.order_id
JOIN customers as cs on cs.customer_id = od.customer_id
JOIN products as pd on pd.product_id = oi.product_id;


-- Q1: Each product's sales
SELECT
  pd.product_id,
  pd.product_name,
  pd.price,
  SUM(oi.amount) as amount_sold,
  pd.price * SUM(oi.amount) AS product_sales
FROM orderItem as oi
JOIN orders as od on od.order_id = oi.order_id
JOIN customers as cs on cs.customer_id = od.customer_id
JOIN products as pd on pd.product_id = oi.product_id
GROUP BY pd.product_id;

-- Q2: BKK branch's best-selling main product 
With sales_inbkk AS (
  SELECT
  	product_id,
  	branch_id,
  	amount
  FROM orderItem
  WHERE branch_id = '1'
), products_bkk AS (
  SELECT
  	product_id,
  	product_name,
  	price,
  	type
  FROM products
  WHERE type = 'Main'
 )
 
SELECT
	p.product_id,
  b.location,
	p.product_name,
  p.price,
  SUM(s.amount) as amount_sold,
  p.price * SUM(s.amount) AS product_sales
FROM products_bkk AS p 
JOIN sales_inbkk AS s on s.product_id = p.product_id
JOIN branches AS b ON s.branch_id = b.branch_id
group BY p.product_id
ORDER BY amount
LIMIT 1;

-- Q3: customer who's ordering both main and dessert dishes
-- Maybe try to use having
SELECT
  oi.order_id,
  cs.customer_name,
  pd.product_name,
  pd.type,
  pd.price,
  oi.amount,
  oi.amount * pd.price AS total
FROM orderItem as oi
JOIN products as pd ON pd.product_id = oi.product_id
JOIN orders AS od ON od.order_id = oi.order_id
JOIN customers as cs on cs.customer_id = od.customer_id
WHERE cs.customer_id IN (
	SELECT
      	c.customer_id
    FROM customers as c
  	JOIN orders AS od ON c.customer_id = od.customer_id
    JOIN orderItem AS oi on od.order_id = oi.order_id
    JOIN products AS pd ON pd.product_id = oi.product_id
    WHERE pd.type IN ('Main', 'Dessert')
    GROUP BY c.customer_id
    HAVING COUNT(distinct pd.type) > 1
);
