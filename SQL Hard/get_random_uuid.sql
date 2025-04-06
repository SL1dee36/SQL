-- Создать функцию на схеме get_random_uuid, которая генерирует случайный ключ в формате UUID и возвращает его

DECLARE
    FUNCTION get_random_uuid RETURN VARCHAR2 IS
        v_raw_guid RAW(16) := SYS_GUID();
        v_hex_guid VARCHAR2(32) := RAWTOHEX(v_raw_guid);
    BEGIN
        RETURN REGEXP_REPLACE(
                   v_hex_guid,
                   '([0-9a-f]{8})([0-9a-f]{4})([0-9a-f]{3})([0-9a-f])([0-9a-f]{3})([0-9a-f]{12})',
                   '\1-\2-4\3-\4\5-\6',
                   1, 0, 'i'
               );
    END;
BEGIN
    DBMS_OUTPUT.PUT_LINE(get_random_uuid());
END;