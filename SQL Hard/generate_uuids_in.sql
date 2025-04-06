-- Создать процедуру generate_uuids, принимающую на вход in коллекцию(nested table) имен пользователя, out ассоциативный массив пользователь-ключ Процедура генерирует всем пользователям случайные uuid-ключи (функция get_random_uuid) и кладет в ассоциативный массив. Процедуру создать внутри анонимного блока. Также внутри него привести пример использования.

DECLARE
  subtype t_username is varchar2(255);
  subtype t_uuid     is varchar2(40);
  TYPE t_username_list IS TABLE OF t_username;

  -- Определяем тип выходной коллекции (Ассоциативный массив: Имя пользователя -> UUID)
  TYPE t_user_uuid_map IS TABLE OF t_uuid INDEX BY t_username;
  l_input_names t_username_list;
  l_output_map  t_user_uuid_map;
  l_current_user t_username;

  PROCEDURE generate_uuids (
    p_usernames IN  t_username_list,
    p_user_map  OUT t_user_uuid_map
  )
  IS
    FUNCTION get_random_uuid RETURN t_uuid
    IS
    BEGIN
      RETURN RAWTOHEX(SYS_GUID());
    END get_random_uuid;

  BEGIN
    -- Проверяем, что входная коллекция не NULL и содержит элементы
    IF p_usernames IS NOT NULL AND p_usernames.COUNT > 0 THEN
      -- Итерируем по входному списку имен пользователей
      FOR i IN p_usernames.FIRST .. p_usernames.LAST LOOP
        IF p_usernames(i) IS NOT NULL THEN
          p_user_map(p_usernames(i)) := get_random_uuid();
        END IF;
      END LOOP;
    END IF;
  END generate_uuids;

BEGIN
  DBMS_OUTPUT.ENABLE(NULL);

  -- 1. Заполняем входную коллекцию примерами имен пользователей
  l_input_names := t_username_list('alice', 'bob', 'charlie', 'david', null, 'alice', 'bob');
	
  DBMS_OUTPUT.PUT_LINE('Input usernames:');
  IF l_input_names IS NOT NULL AND l_input_names.COUNT > 0 THEN
    FOR i IN l_input_names.FIRST .. l_input_names.LAST LOOP
       DBMS_OUTPUT.PUT_LINE('- ' || NVL(l_input_names(i), '[NULL]'));
    END LOOP;
  ELSE
    DBMS_OUTPUT.PUT_LINE('- (empty list)');
  END IF;
  DBMS_OUTPUT.PUT_LINE('--<==========>--');

  -- 2. Вызываем вложенную процедуру
  generate_uuids(p_usernames => l_input_names, p_user_map => l_output_map);

  -- 3. Отображаем результаты из выходного ассоциативного массива
  DBMS_OUTPUT.PUT_LINE('| Generated "User -> UUID" map:');
  IF l_output_map IS NOT NULL AND l_output_map.COUNT > 0 THEN
     -- Итерируем по ассоциативному массиву, используя ключи
     l_current_user := l_output_map.FIRST;
     WHILE l_current_user IS NOT NULL LOOP
       DBMS_OUTPUT.PUT_LINE('| User: ' || RPAD(l_current_user, 10) || '-> UUID: ' || l_output_map(l_current_user));
       l_current_user := l_output_map.NEXT(l_current_user);
     END LOOP;
  ELSE
    DBMS_OUTPUT.PUT_LINE('(UUID not generated or the map is empty)');
  END IF;
  DBMS_OUTPUT.PUT_LINE('--<==========>--');
  -- NULL игнорим, для повторок сохраняется последний сгенерированный UUID.

END;