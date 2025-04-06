-- Создать функцию check_uuid, которая принимает на вход ассоциативный массив (имя пользователя - uuid ключ), имя пользователя, ключ и возврашающает boolean значение true, если переданная связка находится в ассоциативном массиве.
-- Функцию создать внутри анонимного блока. Также внутри него привести пример использования.

DECLARE
  subtype t_username is varchar2(255);
  subtype t_uuid     is varchar2(40);
  TYPE t_user_uuid_map IS TABLE OF t_uuid INDEX BY t_username;

  l_user_map   t_user_uuid_map;
  l_test_user  t_username;
  l_test_uuid  t_uuid;
  l_is_valid   BOOLEAN;

  FUNCTION check_uuid (
    p_user_map IN t_user_uuid_map,
    p_username IN t_username,
    p_uuid     IN t_uuid
  ) RETURN BOOLEAN
  IS
    l_stored_uuid t_uuid;
  BEGIN
    -- 1. Проверяем, существует ли пользователь в массиве
    IF p_user_map.EXISTS(p_username) THEN
      -- 2. Если пользователь существует, получаем его сохраненный UUID
      l_stored_uuid := p_user_map(p_username);

      -- 3. Сравниваем сохраненный UUID с переданным UUID
      IF (l_stored_uuid = p_uuid) OR (l_stored_uuid IS NULL AND p_uuid IS NULL) THEN
        RETURN TRUE;
      ELSE
        RETURN FALSE;
      END IF;
    ELSE
      RETURN FALSE;
    END IF;
  END check_uuid;

BEGIN
  DBMS_OUTPUT.ENABLE(NULL);

  -- 1. Заполняем ассоциативный массив примерами данных
  l_user_map('alice')   := RAWTOHEX(SYS_GUID());
  l_user_map('bob')     := RAWTOHEX(SYS_GUID());
  l_user_map('charlie') := NULL;
  l_user_map('david')   := RAWTOHEX(SYS_GUID());

  DBMS_OUTPUT.PUT_LINE('------');
  l_test_user := l_user_map.FIRST;
  WHILE l_test_user IS NOT NULL LOOP
    DBMS_OUTPUT.PUT_LINE('User: ' || RPAD(l_test_user, 10) || ' -> UUID: ' || NVL(l_user_map(l_test_user), '[NULL]'));
    l_test_user := l_user_map.NEXT(l_test_user);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('------');

  -- 2. Примеры использования функции check_uuid

  -- правильный UUID
  l_test_user := 'alice';
  l_test_uuid := l_user_map('alice'); -- Берем актуальный UUID
  l_is_valid := check_uuid(l_user_map, l_test_user, l_test_uuid);
  DBMS_OUTPUT.PUT_LINE('>> 1: User=' || l_test_user || ', UUID=' || l_test_uuid || ' -> RES: ' || CASE WHEN l_is_valid THEN 'TRUE' ELSE 'FALSE' END);

  --  НЕправильный UUID
  l_test_user := 'bob';
  l_test_uuid := 'INVALID-UUID-STRING-12345'; -- Заведомо неверный UUID
  l_is_valid := check_uuid(l_user_map, l_test_user, l_test_uuid);
  DBMS_OUTPUT.PUT_LINE('>> 2: User=' || l_test_user || ', UUID=' || l_test_uuid || ' -> RES: ' || CASE WHEN l_is_valid THEN 'TRUE' ELSE 'FALSE' END);

  -- НЕсуществующий пользователь
  l_test_user := 'eve';
  l_test_uuid := l_user_map('alice'); -- UUID не имеет значения, т.к. пользователя нет
  l_is_valid := check_uuid(l_user_map, l_test_user, l_test_uuid);
  DBMS_OUTPUT.PUT_LINE('>> 3: User=' || l_test_user || ', UUID=' || l_test_uuid || ' -> RES: ' || CASE WHEN l_is_valid THEN 'TRUE' ELSE 'FALSE' END);

  -- Существующий пользователь, сохраненный UUID = NULL, переданный UUID = NULL
  l_test_user := 'charlie';
  l_test_uuid := NULL;
  l_is_valid := check_uuid(l_user_map, l_test_user, l_test_uuid);
  DBMS_OUTPUT.PUT_LINE('>> 4: User=' || l_test_user || ', UUID=[NULL]' || ' -> RES: ' || CASE WHEN l_is_valid THEN 'TRUE' ELSE 'FALSE' END);

  -- Существующий пользователь, сохраненный UUID = NULL, переданный UUID не NULL
  l_test_user := 'charlie';
  l_test_uuid := l_user_map('david'); -- Какой-то не NULL UUID
  l_is_valid := check_uuid(l_user_map, l_test_user, l_test_uuid);
  DBMS_OUTPUT.PUT_LINE('>> 5: User=' || l_test_user || ', UUID=' || l_test_uuid || ' -> RES: ' || CASE WHEN l_is_valid THEN 'TRUE' ELSE 'FALSE' END);

  -- Передан NULL в качестве имени пользователя
  l_test_user := NULL;
  l_test_uuid := l_user_map('alice');
  l_is_valid := check_uuid(l_user_map, l_test_user, l_test_uuid);
  DBMS_OUTPUT.PUT_LINE('>> 6: User=[NULL]' || ', UUID=' || l_test_uuid || ' -> RES: ' || CASE WHEN l_is_valid THEN 'TRUE' ELSE 'FALSE' END);

END;