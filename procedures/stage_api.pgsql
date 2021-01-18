create or replace procedure add_stage(name_ varchar, department_id_ int, project_id_ int)
language plpgsql    
as $$
declare new_id int;
begin
    if length(name_) = 0
    then raise exception 'не указано имя стадии';
    end if;
    
    if not exists (
        select 1
        from department as d
        where d.id = department_id_
        limit 1)
    then raise exception 'нет такого отдела';
    end if;
    
    if not exists (
        select 1
        from project as p
        where p.id = project_id_
        limit 1)
    then raise exception 'нет такого проекта';
    end if;

    if exists (
        select 1
        from stage as s
        where s.name = name_ 
        and s.project_id = project_id_
        limit 1)
    then raise exception 'у проекта стадия с таким именем существует';
    end if;

    insert into stage(name, department_id, project_id)
    values (name_, department_id_, project_id_)
    returning id into new_id;
    insert into agreement(stage_id)
    values (new_id);
    commit;
end;$$;
