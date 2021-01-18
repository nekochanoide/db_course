create or replace procedure add_employee(name_ varchar, department_id_ int, position_ varchar)
language plpgsql    
as $$
begin
    if length(name_) = 0
    then raise exception 'не указано имя сотрудника';
    end if;

    if length(position_) = 0
    then raise exception 'не указана должность';
    end if;
    
    if not exists (
        select 1
        from department as d
        where d.id = department_id_
        limit 1)
    then raise exception 'нет такого отдела';
    end if;

    insert into stage(name, department_id, project_id)
    values (name_, department_id_, project_id_);
    commit;
end;$$;

create or replace procedure fire_employee(id_ int)
language plpgsql    
as $$
begin
    delete from employee e where e.id = id_;
    commit;
end;$$;

create or replace procedure change_employee_position(id_ int, position_ varchar)
language plpgsql    
as $$
begin
    if length(position_) = 0
    then raise exception 'не указана новая должность';
    end if;

    update employee as e
    set position = position_
    where e.id = id_;
    commit;
end;$$;
