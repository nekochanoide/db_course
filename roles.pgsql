create role admin 
login 
password 'securepass1';

create role employee
login 
password 'securepass1';

grant usage on schema employee_schema to employee;
revoke usage on schema public from employee;
