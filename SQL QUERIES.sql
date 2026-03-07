CREATE TABLE events (
    event_id INTEGER,
    city VARCHAR(50),
    genre VARCHAR(50),
    date DATE,
    ticket_base_price DECIMAL(10, 2)
);

CREATE TABLE event_page_views (
user_id INTEGER,
event_id INTEGER,
hora timestamp,
device_type VARCHAR(10),
country CHAR (5)
);

CREATE TABLE ticket_checkout_started (
    user_id INTEGER,
    event_id INTEGER,
    hora timestamp
);

CREATE TABLE ticket_purchased (
    user_id INTEGER,
    event_id INTEGER,
    hora timestamp,
    ticket_price DECIMAL(10, 2),
    discount_applied INTEGER
);



select * from events;
select * from event_page_views;
select * from ticket_checkout_started;
select * from ticket_purchased;







-- DATA CLEANING - EVENTS
select * from events;

-- Valores nulos
SELECT 
    COUNT(*) - COUNT(event_id) AS nulli_event_id,
    COUNT(*) - COUNT(city) AS nulli_city,
    COUNT(*) - COUNT(genre) AS nulli_genre,
	COUNT(*) - COUNT(date) AS nulli_date,
    COUNT(*) - COUNT(ticket_base_price) AS nulli_prezzi
FROM events;



-- duplicados
SELECT 
     COUNT(event_id) AS duplicate_event_id
FROM events
GROUP BY event_id
HAVING COUNT(*) > 1;
---------------
SELECT 
      event_id, 
	  city,
	  genre,
	  date,
	  COUNT(*) AS conteggio
FROM events
GROUP BY event_id, city, genre, date
HAVING COUNT(*) > 1;


-- Comprobación de categorías y valores (errores ortográficos o outliers)

-- ciudades
SELECT 
      DISTINCT city
FROM events;



-- Generos
SELECT 
      DISTINCT genre
FROM events;


-- PRECIOS
SELECT 
      DISTINCT ticket_base_price
FROM events
ORDER BY ticket_base_price;


-- FECHAS
SELECT 
      DISTINCT date
FROM events
ORDER BY date;





-- 2) DATA CLEANING - event_page_views
SELECT * FROM event_page_views;


-- Valores nulos
SELECT 
    COUNT(*) - COUNT(user_id) AS null_users,
    COUNT(*) - COUNT(event_id) AS null_event_id,
    COUNT(*) - COUNT(hora) AS null_hora,
	COUNT(*) - COUNT(device_type) AS null_device,
    COUNT(*) - COUNT(country) AS null_contry
FROM event_page_views;



--duplicados
SELECT 
      user_id, 
	  event_id,
	  hora,
	  COUNT(*) AS conteo
FROM event_page_views
GROUP BY user_id, event_id, hora
HAVING COUNT(*) > 1;




-- Comprobación de categorías y valores (errores ortográficos o outliers)
-- device
SELECT 
      DISTINCT device_type
FROM event_page_views;

---
SELECT
      COUNT (*),
	  device_type
FROM event_page_views
GROUP BY device_type;



-- Paises
SELECT 
      DISTINCT country
FROM event_page_views;
-----
SELECT
      COUNT (*),
	  country
FROM event_page_views
GROUP BY country;



-- FECHAS
SELECT 
      DISTINCT hora
FROM event_page_views
ORDER BY hora;

------

SELECT 
     MIN(hora),
	 MAX(hora)
FROM event_page_views







-- 3) DATA CLEANING - ticket_checkout_started
SELECT * FROM ticket_checkout_started;


-- Valores nulos
SELECT 
    COUNT(*) - COUNT(user_id) AS null_users,
    COUNT(*) - COUNT(event_id) AS null_event_id
FROM ticket_checkout_started;



--duplicados
SELECT 
      user_id, 
	  event_id,
	  hora,
	  COUNT(*) AS conteo
FROM ticket_checkout_started
GROUP BY user_id, event_id, hora
HAVING COUNT(*) > 1;




-- Check valores de fecha (ouliers)
SELECT 
      DISTINCT hora
FROM ticket_checkout_started
ORDER BY hora;

------

SELECT 
     MIN(hora),
	 MAX(hora)
FROM ticket_checkout_started






-- 4) DATA CLEANING - ticket_purchased
SELECT * FROM ticket_purchased;

-- Valores nulos
SELECT 
    COUNT(*) - COUNT(user_id) AS null_users,
    COUNT(*) - COUNT(event_id) AS null_event_id,
	COUNT(*) - COUNT(hora) AS null_hora,
	COUNT(*) - COUNT(ticket_price) AS null_ticket,
	COUNT(*) - COUNT(discount_applied) AS null_discount
FROM ticket_purchased;



--duplicados
SELECT 
      user_id, 
	  event_id,
	  hora,
	  COUNT(*) AS conteo
FROM ticket_purchased
GROUP BY user_id, event_id, hora
HAVING COUNT(*) > 1;




-- Check valores (ouliers)
--FECHAS
SELECT 
      DISTINCT hora
FROM ticket_purchased
ORDER BY hora;

------

SELECT 
     MIN(hora),
	 MAX(hora)
FROM ticket_purchased



--PRECIOS
SELECT 
      DISTINCT ticket_price
FROM ticket_purchased
ORDER BY ticket_price;

----

SELECT 
     MIN(ticket_price),
	 MAX(ticket_price)
FROM ticket_purchased

----

SELECT
      ticket_price,
	  discount_applied
FROM ticket_purchased
WHERE ticket_price < 2;


-- Discounts
SELECT 
      DISTINCT discount_applied
FROM ticket_purchased
ORDER BY discount_applied;






-- DATOS LIMPIOS
-- NOTA ANALISTA: La simulación ha generado datos limpios.
-- Las estrategias de limpieza que se habrían adoptado podrían discutirse durante la entrevista.



-- FUNNEL
-- 1) compras vs No compras.
CREATE VIEW user_event_conversion AS
SELECT
    v.user_id,
    v.event_id,
    v.hora AS view_date,
    v.device_type,
	v.country,
    p.hora AS purchase_timestamp,
    p.ticket_price
FROM
    event_page_views v
LEFT JOIN
    ticket_purchased p
ON
    v.user_id = p.user_id
    AND v.event_id = p.event_id;


--check
SELECT * FROM user_event_conversion;
DROP VIEW 

-- comparación
SELECT
    COUNT(CASE WHEN purchase_timestamp IS NULL THEN user_id END) AS usuarios_sin_compras,
    COUNT(CASE WHEN purchase_timestamp IS NOT NULL THEN user_id END) AS usuarios_con_compras
FROM user_event_conversion;






select * from events;
select * from event_page_views;
select * from ticket_checkout_started;
select * from ticket_purchased;






-- Reconstrucción completa del embudo por evento
CREATE OR REPLACE VIEW event_funnel AS
SELECT
    epv.user_id,
    epv.event_id,
    epv.hora                  AS view_time,
    epv.device_type,
    epv.country,
    tcs.hora                  AS checkout_time,
    tp.hora                   AS purchase_time,
    tp.ticket_price,
    tp.discount_applied,
    e.genre,
    e.ticket_base_price
FROM event_page_views AS epv
LEFT JOIN ticket_checkout_started AS tcs
    ON epv.user_id  = tcs.user_id
   AND epv.event_id = tcs.event_id
   AND tcs.hora    >= epv.hora          -- checkout después de la vista

LEFT JOIN ticket_purchased AS tp
    ON tcs.user_id  = tp.user_id
   AND tcs.event_id = tp.event_id
   AND tp.hora     >= tcs.hora           -- purchase después del checkout

LEFT JOIN events AS e
    ON epv.event_id = e.event_id;         



SELECT * FROM event_funnel;







select * from events;
select * from event_page_views;
select * from ticket_checkout_started;
select * from ticket_purchased;












