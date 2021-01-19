create or replace procedure add_company(name_ varchar)
language plpgsql    
as $$
begin
    if length(name_) = 0
    then raise exception 'не указано имя компании';
    end if;

    if exists (
        select 1
        from company as с
        where с.name = name_)
    then raise exception 'компания с таким именем существует';
    end if;

    insert into company(name)
    values (name_);
    commit;
end;$$;

create or replace procedure rename_company(name_ varchar, new_name varchar)
language plpgsql    
as $$
begin
    if length(name_) = 0
    then raise exception 'не указано имя компании';
    end if;

    if length(new_name) = 0
    then raise exception 'не указано конечное имя компании';
    end if;

    if not exists (
        select 1
        from company as с
        where с.name = name_
        limit 1)
    then raise exception 'не найдена компания';
    end if;

    if exists (
        select 1
        from company as с
        where с.name = new_name)
    then raise exception 'компания с таким именем существует';
    end if;

    update company as с
    set name = new_name
    where с.name = name_;
    commit;
end;$$;
