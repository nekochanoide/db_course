create or replace procedure employee_schema.add_signature(employee_id_ int, agreement_id_ int)
language plpgsql    
as $$
declare 
    e_pos varchar;
begin
    if not exists (
        select 1
        from employee as e
        where e.id = employee_id_
        limit 1)
    then raise exception 'сотрудник не найден';
    end if;

    select e.position
    from employee e
    where e.id = employee_id_
    into e_pos;

    if e_pos <> 'ГИП'
        and e_pos <> 'ГАП'
        and e_pos <> 'РП'
    then raise exception 'этот сотрудник не может ставить подписи, только ГИП ГАП и РП могут';
    end if;
    
    if not exists (
        select 1
        from agreement as a
        where a.id = agreement_id_
        limit 1)
    then raise exception 'нет указанного согласования';
    end if;

    insert into signature(employee_id, agreement_id)
    values (employee_id_, agreement_id_);

    if e_pos = 'РП'
    then update agreement a
        set date_ = now()
        where a.id = agreement_id_;
    end if;
    commit;
end;$$;
