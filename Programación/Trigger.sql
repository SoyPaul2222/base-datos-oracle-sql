create or replace trigger trig_audit_jugador
    after insert or delete or update on jugador
    for each ROW
begin
    
    if inserting THEN
        insert into auditoria_jug (usuari, accio, codi_jug, data)
        values (USER, 'INSERT', :NEW.codigo, SYSDATE);
    end if;
    
    if deleting THEN
        insert into auditoria_jug (usuari, accio, codi_jug, data)
        values (USER, 'DELETE', :OLD.codigo, SYSDATE);
    end if;

    if updating then
        insert into auditoria_jug (usuari, accio, codi_jug, data)
        values (USER, 'UPDATE', :NEW.codigo, SYSDATE);
    end if;
end;
/