-- В анонимном блоке задать коллекцию (nested table) имен пользователя (не менее 8 пользователей), сгенерировать им ключи, удалить второго и четвертого, добавить ещё двух, поменять ключ для пользователя и проверить, что старый не подходит. После каждого изменения необходимо выводить ассоциативный массив в output (для вывода написать вложенную программу print_array).

DECLARE
  USERNAME_MAX_LENGTH CONSTANT PLS_INTEGER := 50;
  UUID_LENGTH         CONSTANT PLS_INTEGER := 36;
  SUBTYPE username_subtype IS VARCHAR2(USERNAME_MAX_LENGTH);
  TYPE user_map_t IS TABLE OF username_subtype INDEX BY VARCHAR2(UUID_LENGTH);
  v_users user_map_t;

  PROCEDURE print_array IS
    v_uuid VARCHAR2(UUID_LENGTH);
  BEGIN
    IF v_users.COUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('The array is empty.');
      RETURN;
    END IF;

    v_uuid := v_users.FIRST;
    WHILE v_uuid IS NOT NULL LOOP
      DBMS_OUTPUT.PUT_LINE('UUID: ' || v_uuid || ', Username: ' || v_users(v_uuid));
      v_uuid := v_users.NEXT(v_uuid);
    END LOOP;
  END print_array;

  FUNCTION generate_uuid RETURN VARCHAR2 IS
    v_uuid VARCHAR2(UUID_LENGTH);
  BEGIN
    v_uuid := RAWTOHEX(SYS_GUID());
    v_uuid := SUBSTR(v_uuid, 1, 8)  || '-' ||
              SUBSTR(v_uuid, 9, 4)  || '-' ||
              '4' || SUBSTR(v_uuid, 14, 3) || '-' ||
              SUBSTR('89AB', DBMS_RANDOM.VALUE(1, 4), 1) || SUBSTR(v_uuid, 17, 3) || '-' ||
              SUBSTR(v_uuid, 20, 12);
    RETURN v_uuid;
  END generate_uuid;

BEGIN
  DBMS_OUTPUT.ENABLE(NULL);

  -- 1. Populate the associative array.
  DBMS_OUTPUT.PUT_LINE('1. The original array:');
  v_users(generate_uuid()) := 'Smith';      
  v_users(generate_uuid()) := 'Jones';    
  v_users(generate_uuid()) := 'Williams';   
  v_users(generate_uuid()) := 'Brown';     
  v_users(generate_uuid()) := 'Davis';      
  v_users(generate_uuid()) := 'Miller';
  v_users(generate_uuid()) := 'Wilson';    
  v_users(generate_uuid()) := 'Moore';  
  print_array;

  -- 2. Delete users (search by name, more robust).
  DBMS_OUTPUT.PUT_LINE('2. Removing Jones and Brown:'); 
  DECLARE
    v_uuid_to_delete VARCHAR2(UUID_LENGTH);
  BEGIN
    v_uuid_to_delete := v_users.FIRST;
    WHILE v_uuid_to_delete IS NOT NULL LOOP
      IF v_users(v_uuid_to_delete) = 'Jones' THEN   
        v_users.DELETE(v_uuid_to_delete);
      ELSIF v_users(v_uuid_to_delete) = 'Brown' THEN 
        v_users.DELETE(v_uuid_to_delete);
      END IF;
      v_uuid_to_delete := v_users.NEXT(v_uuid_to_delete);
    END LOOP;
  END;
  print_array;

  -- 3. Add new users.
  DBMS_OUTPUT.PUT_LINE('3. Adding Taylor and Anderson:');
  v_users(generate_uuid()) := 'Taylor';   
  v_users(generate_uuid()) := 'Anderson'; 
  print_array;

  -- 4. Change the key for a user (Smith).
  DBMS_OUTPUT.PUT_LINE('4. Change key for Smith:');
  DECLARE
    v_old_uuid VARCHAR2(UUID_LENGTH);
    v_new_uuid VARCHAR2(UUID_LENGTH);
    v_name     username_subtype;
  BEGIN
    v_old_uuid := v_users.FIRST;
    WHILE v_old_uuid IS NOT NULL LOOP
        IF v_users(v_old_uuid) = 'Smith' THEN  
            v_name := v_users(v_old_uuid);
            v_users.DELETE(v_old_uuid);
            v_new_uuid := generate_uuid();
            v_users(v_new_uuid) := v_name;
            EXIT;
        END IF;
      v_old_uuid := v_users.NEXT(v_old_uuid);
    END LOOP;
  END;
  print_array;

  DBMS_OUTPUT.PUT_LINE('5. Checking for deleted key (Jones):');
  DECLARE
    v_temp_name username_subtype;
    v_jones_uuid VARCHAR2(36) := NULL;  
  BEGIN

     v_jones_uuid := v_users.FIRST;     
     WHILE v_jones_uuid IS NOT NULL LOOP  
          IF v_users(v_jones_uuid) = 'Jones' THEN 
              EXIT;
          END IF;
          v_jones_uuid := v_users.NEXT(v_jones_uuid); 
      END LOOP;

    BEGIN
      IF v_jones_uuid IS NOT NULL THEN
          v_temp_name := v_users(v_jones_uuid);
          DBMS_OUTPUT.PUT_LINE('Found: ' || v_temp_name);
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Jones not found (as expected).');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
    END;
  END;
END;