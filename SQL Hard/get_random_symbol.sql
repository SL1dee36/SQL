-- Создать функцию на схеме get_random_symbol, которая возвращает случайную цифру или символ

DECLARE
  FUNCTION generate_random_char RETURN VARCHAR2 IS
    c_allowed_chars CONSTANT VARCHAR2(44) := '1234567890-=qwertyuiop[]asdfghjklzxcvbnm,./';
    v_random_index NUMBER;
    v_random_char VARCHAR2(1);
  BEGIN
    v_random_index := DBMS_RANDOM.VALUE(1, LENGTH(c_allowed_chars));
    v_random_char := SUBSTR(c_allowed_chars, v_random_index, 1);
    RETURN v_random_char;
  END generate_random_char;

BEGIN
  DBMS_OUTPUT.PUT_LINE(generate_random_char());
END;