-- Сгенерировать коллекцию (nested table) со случайным числом элементов и случайными значениями, удалить несколько ее случайных членов с помощью delete (чтобы образовалась разреженная коллекция) Используя исключения вывести на экран индексы удаленных элементов, а для не удалённых вывести индекс и значение Использовать вложенные программы: 1) функция для получения случайного числа 2) функция для генерации коллекции случайных чисел с необязательными аргументами максимального значения и максимальной длины За решение без случайных чисел (с заданием хардкодной коллекции и номеров элементов) даётся 0.25 балла. Полная задача - 1 балл.

DECLARE
  TYPE t_number_collection IS TABLE OF NUMBER;
  l_my_collection t_number_collection;
  l_idx           PLS_INTEGER;
  l_value         NUMBER;
  l_idx_to_delete PLS_INTEGER;
  l_num_deletions PLS_INTEGER;

  -- 1) Вложенная функция для получения случайного целого числа в диапазоне
  FUNCTION get_random_int (p_min IN NUMBER, p_max IN NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN TRUNC(DBMS_RANDOM.VALUE(p_min, p_max + 1)); -- +1 для включения p_max
  END get_random_int;

  -- 2) Вложенная функция для генерации коллекции случайных чисел
  FUNCTION generate_random_collection (
    p_max_value IN NUMBER DEFAULT 1000,
    p_max_size  IN NUMBER DEFAULT 20
  ) RETURN t_number_collection IS
    l_collection t_number_collection := t_number_collection();
    l_actual_size NUMBER;
  BEGIN
     -- Генерируем случайный размер коллекции (от 5 до p_max_size)
     l_actual_size := get_random_int(5, p_max_size);
     DBMS_OUTPUT.PUT_LINE('Generating collection of size: ' || l_actual_size);

     FOR i IN 1..l_actual_size LOOP
       l_collection.EXTEND;
       l_collection(l_collection.LAST) := get_random_int(1, p_max_value);
     END LOOP;

     RETURN l_collection;
  END generate_random_collection;

BEGIN
  DBMS_OUTPUT.ENABLE(NULL);

  -- Генератор коллекций
  l_my_collection := generate_random_collection(p_max_value => 500, p_max_size => 15);

  -- Выводим исходную коллекцию (если она не пустая)
  IF l_my_collection IS NOT NULL AND l_my_collection.COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('--- Original Collection ---');
    l_idx := l_my_collection.FIRST;
    WHILE l_idx IS NOT NULL LOOP
      DBMS_OUTPUT.PUT_LINE('Index: ' || l_idx || ', Value: ' || l_my_collection(l_idx));
      l_idx := l_my_collection.NEXT(l_idx);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('--------------------------');
  ELSE
     DBMS_OUTPUT.PUT_LINE('Generated an empty collection.');
     RETURN; -- Выходим из функции, если она пуста
  END IF;


  -- Определение необходимого кол-ва удалямых данных. например: от 1 до трети размера)
  l_num_deletions := get_random_int(1, CEIL(l_my_collection.COUNT / 3));
  DBMS_OUTPUT.PUT_LINE('Will delete ' || l_num_deletions || ' random elements.');

  -- Удаляем случайные элементы для создания разреженности
  FOR i IN 1..l_num_deletions LOOP
    -- Получаем случайный индекс из существующего диапазона
    IF l_my_collection.COUNT > 0 THEN
        l_idx_to_delete := get_random_int(l_my_collection.FIRST, l_my_collection.LAST);
        l_my_collection.DELETE(l_idx_to_delete);
        DBMS_OUTPUT.PUT_LINE('Attempting to delete element at index: ' || l_idx_to_delete);
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('--- Checking Sparse Collection ---');
  IF l_my_collection.LAST IS NOT NULL THEN
      FOR i IN l_my_collection.FIRST .. l_my_collection.LAST LOOP
        BEGIN
          l_value := l_my_collection(i);
          DBMS_OUTPUT.PUT_LINE('Index: ' || i || ', Value: ' || l_value || ' (exists)');
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Index: ' || i || ' (deleted)');
        END;
      END LOOP;
  ELSE
       DBMS_OUTPUT.PUT_LINE('Collection became empty after deletions.');
  END IF;
   DBMS_OUTPUT.PUT_LINE('-------------------------------------');

END;