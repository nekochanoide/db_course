create or replace procedure add_project(name_ varchar, developer_name varchar)
language plpgsql    
as $$
declare
    dev_id int;

begin
    if length(name_) = 0
    then raise exception 'не указано имя проекта';
    end if;

    if exists (
        select 1
        from project as p
        where p.name = name_
        limit 1)
    then raise exception 'проект с таким именем существует';
    end if;
    
    if not exists (
        select 1
        from developer as d
        where d.name = developer_name
        limit 1)
    then raise exception 'нет такого зайстройщика';
    end if;

-- найти ид застройщика
    select d.id
        from developer as d
        where d.name = developer_name
        limit 1
    into dev_id;

    insert into project(name, developer_id)
    values (name_, dev_id);
    commit;
end;$$;

create or replace procedure rename_project(name_ varchar, new_name varchar)
language plpgsql    
as $$
begin
    if length(name_) = 0
    then raise exception 'не указано имя проекта';
    end if;

    if length(new_name) = 0
    then raise exception 'не указано конечное имя проекта';
    end if;

    if not exists (
        select 1
        from project as p
        where p.name = name_
        limit 1)
    then raise exception 'не найден проект';
    end if;

    if exists (
        select 1
        from project as p
        where p.name = new_name
        limit 1)
    then raise exception 'проект с таким именем существует';
    end if;

    update project as p
    set name = new_name
    where p.name = name_;
    commit;
end;$$;
