DECLARE
    TYPE nested_typ IS TABLE OF NUMBER;
    nt1 nested_typ := nested_typ(1, 2, 3);
    nt2 nested_typ := nested_typ(3, 2, 1);
    nt3 nested_typ := nested_typ(2, 3, 1, 3);
    nt4 nested_typ := nested_typ();
BEGIN
    IF nt1 = nt2 THEN
        DBMS_OUTPUT.PUT_LINE('nt1 = nt2');
    END IF;

    IF (nt1 IN (nt2, nt3, nt4)) THEN
        DBMS_OUTPUT.PUT_LINE('nt1 IN (nt2,nt3,nt4)');
    END IF;

    IF (nt1 SUBMULTISET OF nt3) THEN
        DBMS_OUTPUT.PUT_LINE('nt1 SUBMULTISET OF nt3');
    END IF;

    IF (3 MEMBER OF nt3) THEN
        DBMS_OUTPUT.PUT_LINE('3 MEMBER OF nt3');
    END IF;

    IF (nt3 IS NOT A SET) THEN
        DBMS_OUTPUT.PUT_LINE('nt3 IS NOT A SET');
    END IF;

    IF (nt4 IS EMPTY) THEN
        DBMS_OUTPUT.PUT_LINE('nt4 IS EMPTY');
    END IF;
END;
