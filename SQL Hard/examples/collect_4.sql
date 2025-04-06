DECLARE
  l_tt t_exchange_integer_table := t_exchange_integer_table();
	l_dt_start timestamp(0) with local time zone;
BEGIN
  for i in 1 .. 500000 loop
    l_tt.extend;
    l_tt(l_tt.last) := dbms_random.value(1, 999);
  end loop;
	
	-- 1. без bulk
	l_dt_start := current_timestamp;
	for i in l_tt.first .. l_tt.last loop
		insert into tmp_incub_intgs(id_val) values (l_tt(i));
	end loop;
	
	dbms_output.put_line('Время выполнения без bulk операции: ' || to_char(current_timestamp - l_dt_start));
	rollback;
	
	-- 2. c bulk
	l_dt_start := current_timestamp;
	forall i in l_tt.first .. l_tt.last 
		insert into tmp_incub_intgs(id_val) values (l_tt(i));
	
	dbms_output.put_line('Время выполнения с bulk операции: ' || to_char(current_timestamp - l_dt_start));
	rollback;
	
END;
