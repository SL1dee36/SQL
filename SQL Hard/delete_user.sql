DECLARE
  subtype t_username is varchar2(255);
  subtype t_uuid     is varchar2(40);
  TYPE t_user_uuid_map IS TABLE OF t_uuid INDEX BY t_username;

  l_initial_map t_user_uuid_map;
  l_updated_map t_user_uuid_map;
  l_user_to_delete t_username;

  FUNCTION delete_user (
    p_user_map IN t_user_uuid_map,
    p_username IN t_username      
  ) RETURN t_user_uuid_map        
  IS
    -- Создаем локальную копию входного массива для модификации
    l_local_map t_user_uuid_map := p_user_map;
  BEGIN
    -- Проверяем, что имя пользователя для удаления не NULL
    IF p_username IS NULL THEN
       DBMS_OUTPUT.PUT_LINE('Delete skipped: Username to delete cannot be NULL.');
       RETURN l_local_map;
    END IF;

    -- Проверяем, существует ли пользователь в локальной копии массива
    IF l_local_map.EXISTS(p_username) THEN
      l_local_map.DELETE(p_username);
      DBMS_OUTPUT.PUT_LINE('Function delete_user: User "' || p_username || '" deleted from the map copy.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Function delete_user: User "' || p_username || '" not found in the map. No deletion performed.');
    END IF;

    RETURN l_local_map;
  END delete_user;
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

  -- 1. Инициализируем карту начальными данными
  l_initial_map('alice')   := RAWTOHEX(SYS_GUID());
  l_initial_map('bob')     := RAWTOHEX(SYS_GUID());
  l_initial_map('charlie') := RAWTOHEX(SYS_GUID());
  print_map(l_initial_map, 'Initial Map State');

  -- 2. Пример 1: Удаление существующего пользователя ('bob')
  l_user_to_delete := 'bob';
  DBMS_OUTPUT.PUT_LINE('--- Attempting to delete user: "' || l_user_to_delete || '" ---');
  l_updated_map := delete_user(l_initial_map, l_user_to_delete);
  print_map(l_updated_map, 'Map after deleting existing user (' || l_user_to_delete || ')');
  -- Проверяем, что исходная карта НЕ изменилась
  print_map(l_initial_map, 'Initial Map State (verify unchanged)');

  -- 3. Пример 2: Попытка удаления несуществующего пользователя ('eve')
  l_user_to_delete := 'eve';
   DBMS_OUTPUT.PUT_LINE('--- Attempting to delete user: "' || l_user_to_delete || '" ---');
  l_updated_map := delete_user(l_initial_map, l_user_to_delete);
  print_map(l_updated_map, 'Map after trying to delete non-existent user (' || l_user_to_delete || ')');
  -- Исходная карта также не должна измениться
  print_map(l_initial_map, 'Initial Map State (verify unchanged again)');

  -- 4. Пример 3: Попытка удаления с NULL именем пользователя
  l_user_to_delete := NULL;
  DBMS_OUTPUT.PUT_LINE('--- Attempting to delete user: [NULL] ---');
  l_updated_map := delete_user(l_initial_map, l_user_to_delete);
  print_map(l_updated_map, 'Map after trying to delete NULL user');
   -- Исходная карта также не должна измениться
  print_map(l_initial_map, 'Initial Map State (verify unchanged last time)');

END;