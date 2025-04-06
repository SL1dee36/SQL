DECLARE
    TYPE nested_typ IS TABLE OF NUMBER;
    nt1 nested_typ := nested_typ();
		
		ind number;
		
		procedure print_list(t in nested_typ) is
		begin
			for i in t.first .. t.last loop
			  dbms_output.put_line(t(i));
		  end loop;
		end;
BEGIN
	  --
    dbms_output.put_line(nt1.count);
		nt1.extend;
		dbms_output.put_line(nt1.count);
		dbms_output.put_line(nvl(to_char(nt1(1)), 'NULL'));
		--
		nt1(nt1.last) := 6;
		nt1.extend; nt1(nt1.last) := 3;
		nt1.extend; nt1(nt1.last) := -1;
		nt1.extend; nt1(nt1.last) := -1;
		nt1.extend; nt1(nt1.last) := 7;
		--
		dbms_output.put_line('Состав коллекции 1:');
		print_list(nt1);
		--
		nt1 := nested_typ(3, 3, 7, -1, 2, 0, 5);
		dbms_output.put_line('Состав коллекции 2:');
		print_list(nt1);
		--
		ind := nt1.last;
		nt1.trim(2);
		dbms_output.put_line('Состав коллекции 3:');
		print_list(nt1);
		
		
		if nt1.exists(ind) then
		  dbms_output.put_line('Элемент ' || to_char(ind) || ' есть в коллекции');
		else
			dbms_output.put_line('Элемента ' || to_char(ind) || ' нет в коллекции');
		end if;
END;
