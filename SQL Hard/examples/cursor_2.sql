declare
  l_tt t_exchange_integer_table;
begin
  select t.id_client_inst bulk collect
    into l_tt
    from fw_clients t
   where t.dt_start <= localtimestamp
     and t.dt_stop > localtimestamp
     and t.b_deleted = 0
     and rownum <= 100;
		 
	dbms_output.put_line('�������� ' || l_tt.count || ' �����');
	dbms_output.put_line('�������� ' || sql%rowcount || ' �����');
	
	dbms_output.new_line;
	
	select t.id_client_inst bulk collect
    into l_tt
    from fw_clients t
   where t.dt_start <= localtimestamp
     and t.dt_stop > localtimestamp
     and t.b_deleted = 0
		 and t.id_rec is null
     and rownum <= 100;
		 
	dbms_output.put_line('�������� ' || l_tt.count || ' �����');
	dbms_output.put_line('�������� ' || sql%rowcount || ' �����');

  rollback;
end;
