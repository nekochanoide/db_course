create or replace procedure add_developer(name_ varchar)
language plpgsql    
as $$
begin
    if length(name_) = 0
    then raise exception 'не указано имя застройщика';
    end if;

    if exists (
        select 1
        from developer as d
        where d.name = name_)
    then raise exception 'застройщик с таким именем существует';
    end if;

    insert into developer(name)
    values (name_);
    commit;
end;$$;

create or replace procedure rename_developer(name_ varchar, new_name varchar)
language plpgsql    
as $$
begin
    if length(name_) = 0
    then raise exception 'не указано имя застройщика';
    end if;

    if length(new_name) = 0
    then raise exception 'не указано конечное имя застройщика';
    end if;

    if not exists (
        select 1
        from developer as p
        where p.name = name_
        limit 1)
    then raise exception 'не найден застройщик';
    end if;

    if exists (
        select 1
        from developer as d
        where d.name = new_name)
    then raise exception 'застройщик с таким именем существует';
    end if;

    update developer as d
    set name = new_name
    where d.name = name_;
    commit;
end;$$;
