create or replace procedure add_developer(name_ varchar)
language plpgsql    
as $$
declare
    developer_exists boolean;
begin
    SELECT EXISTS (
        SELECT 1
        FROM developer AS d
        WHERE d.name = name_)
    into developer_exists;
    if not developer_exists then
        insert into developer(name)
        values (name_);
        commit;
    end if;
end;$$;

create or replace procedure remove_developer(name_ varchar)
language plpgsql    
as $$
declare
    developer_exists boolean;
begin
    delete from developer as d
    where d.name = name_;
    commit;
end;$$;

create or replace procedure rename_developer(name_ varchar, new_name varchar)
language plpgsql    
as $$
declare
    developer_exists boolean;
begin
    update developer as d
    set name = new_name
    where d.name = name_;
    commit;
end;$$;

