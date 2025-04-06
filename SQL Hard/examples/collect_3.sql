DECLARE
  nt1     t_exchange_integer_table := t_exchange_integer_table(7, 9, 2, 1, 1, 1, 5, 3, 2, 1);
  new_col t_exchange_integer_table;
	
	l_t_reg_id   t_exchange_integer_table;
	l_t_reg_name t_exchange_string_table;

  procedure print_list(t in t_exchange_integer_table) is
  begin
    for i in t.first .. t.last loop
      dbms_output.put_line(t(i));
    end loop;
  end;
BEGIN
  select distinct value(t) bulk collect
    into new_col
    from table(nt1) t;
		
	dbms_output.put_line('Состав коллекции 1:');
	print_list(new_col);
	
	--
  select t.id_region, t.v_name bulk collect
    into l_t_reg_id, l_t_reg_name
    from fw_region t
   where t.b_deleted = 0
     and t.b_visible = 1;
		 
	for i in 1 .. l_t_reg_id.count loop
		dbms_output.put_line('ID = ' || l_t_reg_id(i) || '; NAME = ' || l_t_reg_name(i));
	end loop;
END;
