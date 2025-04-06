declare
  l_exist_client fw_clients.id_client_inst%type := 5694;
	l_not_client   fw_clients.id_client_inst%type := -1111;
begin
	-- 1.
	update fw_clients t set t.v_status = 'C' where t.id_client_inst = l_exist_client;
	
	if sql%notfound then
		dbms_output.put_line('��� ����� ��� ����������');
	else
		dbms_output.put_line('���� ������ ��� ����������');
	end if;
	
	dbms_output.put_line('��������� ' || sql%rowcount || ' �����');
	
	-- 2.
	update fw_clients t set t.v_status = 'C' where t.id_client_inst = l_not_client;

	if sql%rowcount = 0 then
		dbms_output.put_line('��� ����� ��� ����������');
	end if;
	
	rollback;
end;  
