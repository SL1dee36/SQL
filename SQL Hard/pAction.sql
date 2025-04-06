-- Сделать функцию delete_user, которая принимает на вход ассоциативный массив(имя пользователя - uuid ключ), имя пользователя. 
-- Функция удаляет из текущего ассоциативного массива связку данного пользователя и возвращает обновленный ассоциативный массив (имя пользователя - uuid ключ)
-- Функцию создать внутри анонимного блока. Также внутри него привести пример использования.

DECLARE
  subtype t_username is varchar2(255);
  subtype t_uuid     is varchar2(40);
  TYPE t_user_uuid_map IS TABLE OF t_uuid INDEX BY t_username;
  l_user_map t_user_uuid_map;

  PROCEDURE save_user (
    p_user_map IN OUT t_user_uuid_map,
    p_username IN t_username,
    pAction    IN PLS_INTEGER -- 1: Add, 2: Update UUID, 3: Delete
  )
  IS
    l_new_uuid t_uuid;

    FUNCTION get_random_uuid RETURN t_uuid
    IS
    BEGIN
      RETURN RAWTOHEX(SYS_GUID());
    END get_random_uuid;

  BEGIN
    IF p_username IS NULL THEN
       DBMS_OUTPUT.PUT_LINE('Action skipped: Username cannot be NULL.');
       RETURN;
    END IF;

    CASE pAction
      WHEN 1 THEN
        IF p_user_map.EXISTS(p_username) THEN
          DBMS_OUTPUT.PUT_LINE('Action 1 (Add): + User "' || p_username || '" already exists. UUID not changed.');
        ELSE
          l_new_uuid := get_random_uuid();
          p_user_map(p_username) := l_new_uuid;
          DBMS_OUTPUT.PUT_LINE('Action 1 (Add): + User "' || p_username || '" added with UUID: ' || l_new_uuid);
        END IF;

      WHEN 2 THEN
        IF p_user_map.EXISTS(p_username) THEN
          l_new_uuid := get_random_uuid();
          p_user_map(p_username) := l_new_uuid;
          DBMS_OUTPUT.PUT_LINE('Action 2 (Update): * New UUID generated for user "' || p_username || '": ' || l_new_uuid);
        ELSE
          DBMS_OUTPUT.PUT_LINE('Action 2 (Update): * User "' || p_username || '" not found. Update impossible.');
        END IF;

      WHEN 3 THEN
        IF p_user_map.EXISTS(p_username) THEN
          p_user_map.DELETE(p_username);
          DBMS_OUTPUT.PUT_LINE('Action 3 (Delete): - User "' || p_username || '" deleted.');
        ELSE
           DBMS_OUTPUT.PUT_LINE('Action 3 (Delete): - User "' || p_username || '" not found. Deletion not required.');
        END IF;

      ELSE
        DBMS_OUTPUT.PUT_LINE('Unknown action: ' || pAction || ' for user "' || p_username || '".');

    END CASE;
  END save_user;

  PROCEDURE print_map (p_map IN t_user_uuid_map, p_title IN VARCHAR2)
  IS
     l_user t_username;
  BEGIN
     DBMS_OUTPUT.PUT_LINE(p_title || ':');
     IF p_map IS NULL OR p_map.COUNT = 0 THEN
       DBMS_OUTPUT.PUT_LINE('  (map is empty)');
     ELSE
       l_user := p_map.FIRST;
       WHILE l_user IS NOT NULL LOOP
         DBMS_OUTPUT.PUT_LINE('  User: ' || RPAD(l_user, 10) || ' -> UUID: ' || NVL(p_map(l_user), '[NULL]'));
         l_user := p_map.NEXT(l_user);
       END LOOP;
     END IF;
     DBMS_OUTPUT.PUT_LINE('.');
  END print_map;

BEGIN
  DBMS_OUTPUT.ENABLE(buffer_size => NULL);

  l_user_map('alice')   := RAWTOHEX(SYS_GUID());
  l_user_map('bob')     := RAWTOHEX(SYS_GUID());
  print_map(l_user_map, 'Initial Map State');

  save_user(l_user_map, 'charlie', 1);
  print_map(l_user_map, 'After adding charlie');

  save_user(l_user_map, 'alice', 1);
  print_map(l_user_map, 'After trying to add alice again');

  save_user(l_user_map, 'bob', 2);
  print_map(l_user_map, 'After updating UUID for bob');

  save_user(l_user_map, 'eve', 2);
  print_map(l_user_map, 'After trying to update UUID for eve');

  save_user(l_user_map, 'alice', 3);
  print_map(l_user_map, 'After deleting alice');

  save_user(l_user_map, 'alice', 3);
  print_map(l_user_map, 'After trying to delete alice again');

  save_user(l_user_map, 'bob', 99);
  print_map(l_user_map, 'After invalid action for bob');

  save_user(l_user_map, NULL, 1);
  print_map(l_user_map, 'After action attempt with NULL name');

END;