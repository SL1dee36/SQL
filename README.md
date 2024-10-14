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
