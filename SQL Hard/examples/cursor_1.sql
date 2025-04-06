declare
  l_exist_client fw_clients.id_client_inst%type := 5694;
	l_not_client   fw_clients.id_client_inst%type := -1111;
begin
	-- 1.
	update fw_clients t set t.v_status = 'C' where t.id_client_inst = l_exist_client;
	
	if sql%notfound then
		dbms_output.put_line('Нет строк для обновления');
	else
		dbms_output.put_line('Есть строки для обновления');
	end if;
	
	dbms_output.put_line('Обновлено ' || sql%rowcount || ' строк');
	
	-- 2.
	update fw_clients t set t.v_status = 'C' where t.id_client_inst = l_not_client;

	if sql%rowcount = 0 then
		dbms_output.put_line('Нет строк для обновления');
	end if;
	
	rollback;
end;  
