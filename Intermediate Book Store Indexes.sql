--View first 10 customers
SELECT
    *
FROM
    customers
LIMIT
    10;

--View first 10 orders
SELECT
    *
FROM
    orders
LIMIT
    10;

--View first 10 books
SELECT
    *
FROM
    books
LIMIT
    10;

--Examine indexes already present in customers table
SELECT
    *
FROM
    pg_Indexes
WHERE
    tablename = 'customers';

--Examine indexes already present in orders table
SELECT
    *
FROM
    pg_Indexes
WHERE
    tablename = 'orders';

--Examine indexes already present in books table
SELECT
    *
FROM
    pg_Indexes
WHERE
    tablename = 'books';

--Analyze performance of selecting customer_ids with orders more than 18
EXPLAIN ANALYZE
SELECT
    customer_id,
    quantity
FROM
    orders
WHERE
    quantity > 18;

--add a partial index
CREATE INDEX orders_customer_id_quantity_idx ON orders (customer_id, quantity)
WHERE
    quantity > 18;

--Examine indexes already present in orders table after creating partial index

EXPLAIN ANALYZE
SELECT
    customer_id,
    quantity
FROM
    orders
WHERE
    quantity > 18;

--analyze selecting selecting customers with id greater than 500
EXPLAIN ANALYZE
SELECT
    *
FROM
    customers
WHERE
    customer_id > 500;

--Create primary key on customers table
ALTER TABLE
    customers
ADD
    CONSTRAINT customers_pkey PRIMARY KEY (customer_id);

--Examine indexes already present in customers table after adding primary key
SELECT
    *
FROM
    pg_Indexes
WHERE
    tablename = 'customers';

--analyze customers with id greater than 500
EXPLAIN ANALYZE
SELECT
    *
FROM
    customers
WHERE
    customer_id > 500;

--order customers table by customer_id
CLUSTER customers USING customers_pkey;

--Did the cluster work.
SELECT
    *
FROM
    customers
LIMIT
    10;

--build multicolumn index for orders table using customer_id and book_id columns
CREATE INDEX orders_customer_id_book_id_idx ON orders (customer_id, book_id);

--Check indexes already present in orders table after creating multicolumn index
SELECT
    *
FROM
    pg_Indexes
WHERE
    tablename = 'orders';

--Drop the multicolumn index
DROP INDEX IF EXISTS orders_customer_id_book_id_idx;

--Check indexes already present in orders table after dropping multicolumn index
SELECT
    *
FROM
    pg_Indexes
WHERE
    tablename = 'orders';

--Re-create multicolumn index with one additional column
CREATE INDEX orders_customer_id_book_id_quantity_idx ON orders (customer_id, book_id);

--create index for author and title in books table
CREATE INDEX books_author_title_idx ON books (author, title);

--analyze cost before creating index
EXPLAIN ANALYZE
SELECT
    *
FROM
    orders
WHERE
    ((quantity * price_base)) > 100;

--create index with quantity and price_base in orders table
CREATE INDEX orders_quantity_price_base_idx ON orders (quantity, price_base);

--analyze cost after creating index
EXPLAIN ANALYZE
SELECT
    *
FROM
    orders
WHERE
    ((quantity * price_base)) > 100;