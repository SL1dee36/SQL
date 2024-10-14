## Конспект по SQL запросам

Этот конспект охватывает основные команды SQL, используемые для работы с данными, с примерами и определениями.

**I. DML (Data Manipulation Language):**

* **SELECT:** Извлечение данных из одной или нескольких таблиц.

    * **Синтаксис:**
        ```sql
        SELECT column1, column2, ...
        FROM table_name
        WHERE condition
        ORDER BY column_name ASC/DESC
        LIMIT number;
        ```

    * **Пример:** Выбрать имена и фамилии всех клиентов из таблицы "Customers" с ID больше 10, отсортировать по фамилии в алфавитном порядке и ограничить вывод 5 записями:
        ```sql
        SELECT FirstName, LastName
        FROM Customers
        WHERE CustomerID > 10
        ORDER BY LastName ASC
        LIMIT 5;
        ```

* **INSERT:** Добавление новых строк в таблицу.

    * **Синтаксис:**
        ```sql
        INSERT INTO table_name (column1, column2, ...)
        VALUES (value1, value2, ...);
        ```

    * **Пример:** Добавить нового клиента в таблицу "Customers":
        ```sql
        INSERT INTO Customers (FirstName, LastName, City, Country)
        VALUES ('John', 'Doe', 'New York', 'USA');
        ```

* **UPDATE:** Изменение существующих данных в таблице.

    * **Синтаксис:**
        ```sql
        UPDATE table_name
        SET column1 = value1, column2 = value2, ...
        WHERE condition;
        ```

    * **Пример:** Обновить город клиента с ID 1:
        ```sql
        UPDATE Customers
        SET City = 'London'
        WHERE CustomerID = 1;
        ```

* **DELETE:** Удаление строк из таблицы.

    * **Синтаксис:**
        ```sql
        DELETE FROM table_name
        WHERE condition;
        ```

    * **Пример:** Удалить всех клиентов из города 'London':
        ```sql
        DELETE FROM Customers
        WHERE City = 'London';
        ```


**II. DDL (Data Definition Language):**

* **CREATE TABLE:** Создание новой таблицы.

    * **Синтаксис:**
        ```sql
        CREATE TABLE table_name (
            column1 datatype constraints,
            column2 datatype constraints,
            ...
        );
        ```

    * **Пример:** Создать таблицу "Products":
        ```sql
        CREATE TABLE Products (
            ProductID INT PRIMARY KEY,
            ProductName VARCHAR(255),
            Price DECIMAL(10, 2)
        );
        ```

* **ALTER TABLE:** Изменение структуры существующей таблицы.

    * **Синтаксис (добавление столбца):**
        ```sql
        ALTER TABLE table_name
        ADD column_name datatype constraints;
        ```

    * **Синтаксис (удаление столбца):**
        ```sql
        ALTER TABLE table_name
        DROP COLUMN column_name;
        ```
    * **Пример (добавление столбца "Description"):**
        ```sql
        ALTER TABLE Products
        ADD Description TEXT;
        ```

* **DROP TABLE:** Удаление таблицы.

    * **Синтаксис:**
        ```sql
        DROP TABLE table_name;
        ```

* **TRUNCATE TABLE:** Удаление всех данных из таблицы.

    * **Синтаксис:**
        ```sql
        TRUNCATE TABLE table_name;
        ```


**III. Другие важные команды и клаузы:**

* **WHERE:** Фильтрация данных.  Примеры условий: `=`, `!=`, `>`, `<`, `>=`, `<=`, `BETWEEN`, `LIKE`, `IN`, `IS NULL`.

* **ORDER BY:** Сортировка.  `ASC` (по возрастанию, по умолчанию) или `DESC` (по убыванию).

* **GROUP BY:** Группировка строк.

* **HAVING:** Фильтрация после группировки.

* **JOIN:** Объединение таблиц. Типы: `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL OUTER JOIN`.  Пример `INNER JOIN`:
    ```sql
    SELECT Customers.FirstName, Orders.OrderID
    FROM Customers
    INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;
    ```


* **UNION:** Объединение результатов запросов.

* **INTERSECT/EXCEPT (MINUS):**  Нахождение общих/различных строк.

* **DISTINCT:**  Исключение дубликатов.

* **LIMIT/TOP:** Ограничение количества возвращаемых строк.

* **AS:**  Создание алиасов.

* **BETWEEN:**  Выбор значений в диапазоне.

* **IN:**  Выбор значений из списка.

* **LIKE:**  Поиск по шаблону.

* **NULL:**  Обработка отсутствующих значений.


**IV. Агрегатные функции:**

* **COUNT():** Подсчет.

* **SUM():** Сумма.

* **AVG():** Среднее.

* **MAX():** Максимум.

* **MIN():** Минимум.  Пример: найти максимальную цену в таблице "Products":
    ```sql
    SELECT MAX(Price)
    FROM Products;
    ```



### DQL (Data Query Language) — это подмножество SQL, специализирующееся на запросах к данным.  На практике, когда говорят о DQL, обычно имеют в виду команду `SELECT` и связанные с ней клаузы.  Хотя `SELECT` — единственная команда DQL, её гибкость и разнообразие опций делают её мощным инструментом для извлечения данных.

Вот расширенный обзор DQL с фокусом на `SELECT` и связанных клаузах:

**SELECT:**

* **Базовый синтаксис:**

```sql
SELECT column1, column2, ...  -- список выбираемых столбцов
FROM table_name           -- таблица, из которой выбираются данные
WHERE condition           -- условие фильтрации (необязательно)
ORDER BY column_name      -- сортировка (необязательно)
LIMIT number;           -- ограничение количества строк (необязательно)
```

* **`*` (звездочка):**  Выбор всех столбцов.

```sql
SELECT * FROM Customers; -- выбирает все столбцы из таблицы Customers
```

* **DISTINCT:** Удаление дубликатов строк.

```sql
SELECT DISTINCT City FROM Customers; -- выбирает уникальные города из таблицы Customers
```

* **Алиасы (AS):**  Переименование столбцов или таблиц для удобства.

```sql
SELECT FirstName AS Name, LastName AS Surname
FROM Customers AS Clients;  -- выбирает имена и фамилии, переименовывая столбцы и таблицу
```


**WHERE:**

* **Операторы сравнения:** `=`, `!=`, `>`, `<`, `>=`, `<=`.

* **Логические операторы:** `AND`, `OR`, `NOT`.

* **BETWEEN:**  Выбор значений в заданном диапазоне.

```sql
SELECT * FROM Products WHERE Price BETWEEN 10 AND 50; -- выбирает продукты с ценой от 10 до 50
```

* **LIKE:**  Поиск по шаблону. `%` – любой набор символов, `_` – один любой символ.

```sql
SELECT * FROM Customers WHERE LastName LIKE 'S%'; -- выбирает клиентов, чья фамилия начинается с "S"
```

* **IN:**  Выбор значений из списка.

```sql
SELECT * FROM Customers WHERE Country IN ('USA', 'UK', 'Canada'); -- выбирает клиентов из указанных стран
```

* **IS NULL:** Проверка на NULL значения.

```sql
SELECT * FROM Customers WHERE Phone IS NULL; -- выбирает клиентов без номера телефона
```


**ORDER BY:**

* **Сортировка по одному или нескольким столбцам.**

```sql
SELECT * FROM Products ORDER BY Price ASC, ProductName DESC; -- сортирует продукты по цене по возрастанию, затем по имени по убыванию
```


**LIMIT (или TOP, FETCH FIRST):**

* **Ограничение количества возвращаемых строк.**

```sql
SELECT * FROM Customers LIMIT 10; -- выбирает первые 10 строк
```



**Подзапросы:**

* **Использование запроса `SELECT` внутри другого запроса.**

```sql
SELECT * FROM Products WHERE Price > (SELECT AVG(Price) FROM Products); -- выбирает продукты с ценой выше средней
```



**Объединение результатов нескольких запросов SELECT:**

* **UNION:**  Объединяет результаты, удаляя дубликаты.
* **UNION ALL:** Объединяет результаты, сохраняя дубликаты.
* **INTERSECT:** Возвращает общие строки.
* **EXCEPT (или MINUS):** Возвращает строки, присутствующие в первом запросе, но отсутствующие во втором.


DQL — это основной инструмент для извлечения и фильтрации данных в SQL.  Понимание этих клауз и их комбинаций позволяет выполнять сложные запросы и получать необходимые данные из базы данных.  Постоянная практика — ключ к мастерству в DQL.
