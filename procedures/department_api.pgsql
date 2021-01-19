create or replace procedure add_department(name_ varchar, company_name varchar)
language plpgsql    
as $$
declare
    company_id_ int;
begin
    if length(name_) = 0
    then raise exception 'не указано имя отдела';
    end if;
    
    if not exists (
        select 1
        from company as c
        where c.name = company_name
        limit 1)
    then raise exception 'нет такой компании';
    end if;

-- найти ид компании
    select c.id
        from company as c
        where c.name = company_name
        limit 1
    into company_id_;

    if exists (
        select 1
        from department as d
        where d.name = name_ 
        and d.company_id = company_id_
        limit 1)
    then raise exception 'в компании отдел с таким именем существует';
    end if;

    insert into department(name, company_id)
    values (name_, company_id_);
    commit;
end;$$;

create or replace procedure rename_department(id_ int, new_name varchar)
language plpgsql    
as $$
declare
    company_id_ int;
begin
    if length(new_name) = 0
    then raise exception 'не указано новое имя отдела';
    end if;

    if not exists (
        select 1
        from department as d
        where d.id = id_
        limit 1)
    then raise exception 'не найден отдел';
    end if;

    -- найти ид компании
    select d.company_id
        from department as d
        where d.id = id_
        limit 1
    into company_id_;

    if exists (
        select 1
        from department as d
        where d.name = new_name
        and d.company_id = company_id_
        limit 1)
    then raise exception 'отдел с таким именем существует';
    end if;

    update department as d
    set name = new_name
    where d.id = id_;
    commit;
end;$$;
