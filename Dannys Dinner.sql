CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  
  ---------------------------
  -- Project Questions --
  ---------------------------
  
/* 1. What is the total amount each customer spent at the restaurant? */
SELECT s.customer_id, sum(price) AS Total_Purchase
FROM sales s
LEFT JOIN menu m
	ON s.product_id = m.product_id
GROUP BY s.customer_id;

/* 2. How many days has each customer visited the restaurant? */
SELECT customer_id, COUNT(DISTINCT order_date) AS Total_days
FROM sales
GROUP BY customer_id;

/* 3. What was the first item from the menu purchased by each customer? */
SELECT s.customer_id, s.order_date, m.product_name
FROM sales s
LEFT JOIN menu m
	ON s.product_id = m.product_id
GROUP BY s.customer_id 
ORDER BY s.order_date ASC;


/* 4. What is the most purchased item on the menu and how many times was it purchased by all customers? */
SELECT m.product_name, count(s.product_id) AS Times_purchased
FROM menu m
JOIN sales s
	ON s.product_id = m.product_id
GROUP BY s.product_id
ORDER BY times_purchased DESC;


/* 5. Which item was the most popular for each customer? */
WITH cte_most_popular AS (
	SELECT s.customer_id, 
		m.product_name, 
        COUNT(m.product_id) AS order_count,
		DENSE_RANK() OVER (PARTITION BY s.customer_id
		ORDER BY count(m.product_id) DESC) AS order_rank
	FROM sales s
	LEFT JOIN menu m
		ON s.product_id = m.product_id
	GROUP BY s.customer_id, m.product_name)

SELECT customer_id, product_name, order_count
FROM cte_most_popular
WHERE order_rank = 1;

/* 6. Which item was purchased first by the customer after they became a member? */
WITH cte_menu_member AS (
	SELECT s.customer_id, 
		s.order_date, 
        s.product_id, 
        m.join_date,
		DENSE_RANK () OVER(PARTITION BY s.customer_id
		ORDER BY s.order_date) AS ranking
	FROM sales s
	JOIN members m
		ON s.customer_id = m.customer_id
	WHERE s.order_date >= m.join_date)

SELECT s.customer_id, s.order_date, m.product_name
FROM cte_menu_member AS s
JOIN menu m
	ON s.product_id = m.product_id
WHERE ranking = 1
ORDER BY s.customer_id;

/* 7. Which item was purchased just before the customer became a member? */
WITH cte_item_before AS (
	SELECT s.customer_id, 
		s.order_date, 
        s.product_id, 
        m.join_date,
		DENSE_RANK() OVER(PARTITION BY s.customer_id
		ORDER BY s.order_date DESC) AS rank_number
    FROM sales s
    JOIN members m
		ON s.customer_id = m.customer_id
	WHERE s.order_date < m.join_date)

SELECT s.customer_id, s.order_date, mn.product_name
FROM cte_item_before s
JOIN menu mn
	ON s.product_id = mn.product_id
WHERE rank_number = 1
ORDER BY s.customer_id;


/* 8. What is the total items and amount spent for each member before they became a member? */
SELECT 
	s.customer_id, 
    COUNT(DISTINCT s.product_id) AS unique_menu_item,
    SUM(mn.price) AS total_sales
FROM sales s
JOIN members AS m
	ON s.customer_id = m.customer_id
JOIN menu mn
	ON s.product_id = mn.product_id
WHERE s.order_date < m.join_date
GROUP BY s.customer_id;


/* 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - 
how many points would each customer have? */
WITH cte_price_points AS (
	SELECT *,
		CASE
			WHEN product_id = 1 THEN price * 20
			ELSE price * 10
		END AS points
	FROM menu)

SELECT s.customer_id, SUM(p.points) AS total_points
FROM cte_price_points AS p
JOIN sales s
	ON p.product_id = s.product_id
GROUP BY s.customer_id;


/* 10. In the first week after a customer joins the program (including their join date) they earn 
2x points on all items, not just sushi - how many points do customer A and B have at the end of January? */
WITH cte_dates AS (
	SELECT *,
		date_add(join_date, INTERVAL 6 day) AS valid_date,
		last_day('2021-01-31') AS end_date
    FROM members )
    
SELECT d.customer_id, s.order_date, d.join_date, 
 d.valid_date, d.end_date, m.product_name, m.price,
	SUM(CASE
		WHEN m.product_name = 'sushi' THEN 2 * 10 * m.price
		WHEN s.order_date BETWEEN d.join_date AND d.valid_date THEN 2 * 10 * m.price
		ELSE 10 * m.price
	END) AS points
FROM cte_dates AS d
JOIN sales AS s
	ON d.customer_id = s.customer_id
JOIN menu AS m
	ON s.product_id = m.product_id
WHERE s.order_date < d.end_date
GROUP BY d.customer_id
ORDER BY d.customer_id;