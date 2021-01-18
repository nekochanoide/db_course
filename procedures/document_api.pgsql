create or replace procedure create_document(name_ varchar, stage_id_ int, employee_id_ int)
language plpgsql    
as $$
declare new_id int;
    emps_dep int;
    stage_dep int;
    stage_date date;
begin
    if length(name_) = 0
    then raise exception 'нет названия документа';
    end if;
    
    if not exists (
        select 1
        from stage as s
        where s.id = stage_id_
        limit 1)
    then raise exception 'нет такой стадии';
    end if;

    select e.department_id
    from employee e
    where e.id = employee_id_
    into emps_dep;

    select s.department_id
    from stage s
    where s.id = stage_id_
    into stage_dep;

    if emps_dep <> stage_dep
    then raise exception 'сотрудник не занимается данной стадией';
    end if;

    select s.date_
    from stage s
    where s.id = stage_id_
    into stage_date;

    if stage_date is null
    then raise exception 'стадия еще не согласована';
    end if;

    insert into document(name, stage_id)
    values (name_, stage_id_)
    returning id into new_id;

    insert into document_change(document_id, employee_id, date_, name)
    values (new_id, employee_id_, now(), 'создание');

    commit;
end;$$;

create or replace procedure delete_document(id_ int, stage_id_ int, employee_id_ int)
language plpgsql    
as $$
declare
    emps_dep int;
    stage_dep int;
begin
    if not exists (
        select 1
        from document as d
        where d.id = id_
        limit 1)
    then raise exception 'документа нет';
    end if;

    if not exists (
        select 1
        from stage as s
        where s.id = stage_id_
        limit 1)
    then raise exception 'нет такой стадии';
    end if;

    select e.department_id
    from employee e
    where e.id = employee_id_
    into emps_dep;

    select s.department_id
    from stage s
    where s.id = stage_id_
    into stage_dep;

    if emps_dep <> stage_dep
    then raise exception 'сотрудник не занимается данной стадией';
    end if;

    delete from document d
    where d.id = id_;

    insert into document_change(document_id, employee_id, date_, name)
    values (id_, employee_id_, now(), 'удаление');

    commit;
end;$$;

create or replace procedure change_document(id_ int, stage_id_ int, employee_id_ int)
language plpgsql    
as $$
declare
    emps_dep int;
    stage_dep int;
begin
    if not exists (
        select 1
        from document as d
        where d.id = id_
        limit 1)
    then raise exception 'документа нет';
    end if;

    if not exists (
        select 1
        from stage as s
        where s.id = stage_id_
        limit 1)
    then raise exception 'нет такой стадии';
    end if;

    select e.department_id
    from employee e
    where e.id = employee_id_
    into emps_dep;

    select s.department_id
    from stage s
    where s.id = stage_id_
    into stage_dep;

    if emps_dep <> stage_dep
    then raise exception 'сотрудник не занимается данной стадией';
    end if;

    insert into document_change(document_id, employee_id, date_, name)
    values (id_, employee_id_, now(), 'изменение');

    commit;
end;$$;
