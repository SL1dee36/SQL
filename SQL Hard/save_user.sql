-- В анонимном блоке задать коллекцию (nested table) имен пользователя(не менее 8 пользователей), сгенерировать им ключи, затем в зависимости от первой буквы имени: Для первой половины русского алфавита (примерно) - сенерировать новые ключи Для второй половины русского алфавита (примерно) - удалить Использовать save_user. save_user может присутствовать в коде только один раз. За решение без перечисления алфавита дается 1 балл. Перебором - 0.5 балла.

DECLARE
    TYPE username_t IS TABLE OF VARCHAR2(50);

    TYPE user_map_t IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(36);

    v_users user_map_t;

    v_usernames username_t := username_t(
        'Алексей', 'Борис', 'Виктор', 'Григорий', 'Дмитрий', 'Евгений', 'Жанна', 'Зинаида',
        'Иван', 'Кирилл', 'Людмила', 'Марина', 'Наталья', 'Ольга', 'Павел', 'Роман',
        'Светлана', 'Татьяна', 'Ульяна', 'Фёдор', 'Харитон', 'Цветана', 'Чеслав', 'Шамиль',
        'Эдуард', 'Юлия', 'Ярослав', 'Аркадий', 'Василиса', 'Галина'
    );


    PROCEDURE print_array(p_users IN user_map_t, p_usernames IN username_t) IS
        v_uuid   VARCHAR2(36);
        v_index  PLS_INTEGER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--------------------');
        IF p_users.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Массив пуст.');
            RETURN;
        END IF;

        v_uuid := p_users.FIRST;
        WHILE v_uuid IS NOT NULL LOOP
            v_index := p_users(v_uuid);
              IF LENGTH(v_uuid) > 36 THEN -- Проверка на всякий случай
                DBMS_OUTPUT.PUT_LINE('Error: UUID too long: ' || v_uuid);
              ELSE
                DBMS_OUTPUT.PUT_LINE('UUID: ' || v_uuid || ', Username: ' || p_usernames(v_index));
            END IF;
            v_uuid := p_users.NEXT(v_uuid);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('--------------------');
    END print_array;

    FUNCTION generate_uuid RETURN VARCHAR2 IS
        v_uuid VARCHAR2(36);
    BEGIN
        v_uuid := RAWTOHEX(SYS_GUID());
        v_uuid := SUBSTR(v_uuid, 1, 8)  || '-' ||
                  SUBSTR(v_uuid, 9, 4)  || '-' ||
                  '4' || SUBSTR(v_uuid, 14, 3) || '-' ||
                  SUBSTR('89AB', DBMS_RANDOM.VALUE(1, 4), 1) || SUBSTR(v_uuid, 17, 3) || '-' ||
                  SUBSTR(v_uuid, 20, 12);
        RETURN v_uuid;
    END generate_uuid;

    -- Процедура сохранения/обновления пользователя.
    PROCEDURE save_user(p_uuid IN VARCHAR2, p_index IN PLS_INTEGER) IS
    BEGIN
        v_users(p_uuid) := p_index;
    END save_user;

     PROCEDURE delete_user(p_uuid IN VARCHAR2) IS
    BEGIN
       v_users.DELETE(p_uuid);
    END delete_user;

BEGIN
    DBMS_OUTPUT.PUT_LINE('1. Исходный массив:');
    FOR i IN 1..v_usernames.COUNT LOOP
        save_user(generate_uuid(), i);
    END LOOP;
    print_array(v_users, v_usernames);

    -- 2. Обработка пользователей в зависимости от первой буквы имени.
    DBMS_OUTPUT.PUT_LINE('2. Обработка пользователей:');
    DECLARE
        v_uuid          VARCHAR2(36);
        v_first_letter  VARCHAR2(2 CHAR);
        v_index         PLS_INTEGER;
    BEGIN
        v_uuid := v_users.FIRST;
        WHILE v_uuid IS NOT NULL LOOP
            v_index := v_users(v_uuid);
            v_first_letter := SUBSTR(v_usernames(v_index), 1, 2);

            IF v_first_letter < 'П' THEN
                save_user(generate_uuid(), v_index);
            ELSE
                delete_user(v_uuid);
            END IF;

            v_uuid := v_users.NEXT(v_uuid);
        END LOOP;
    END;

    print_array(v_users, v_usernames);
END;
