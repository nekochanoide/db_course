CREATE TABLE developer (
  id serial PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE project (
  id serial PRIMARY KEY,
  name VARCHAR(255),
  developer_id integer
);

CREATE TABLE stage (
  id serial PRIMARY KEY,
  name VARCHAR(255),
  department_id integer,
  project_id integer
);

CREATE TABLE department (
  id serial PRIMARY KEY,
  name VARCHAR(255),
  company_id integer
);

CREATE TABLE company (
  id serial PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE agreement (
  id serial PRIMARY KEY,
  stage_id integer,
  date_ date
);

CREATE TABLE signature (
  id serial PRIMARY KEY,
  employee_id integer,
  agreement_id integer
);

CREATE TABLE employee (
  id serial PRIMARY KEY,
  name VARCHAR(255),
  position VARCHAR(255), -- ГИП, ГАП, АДМИН, РУКОВОДИТЕЛЬ ПРОЕКТА
  department_id integer
);

CREATE TABLE document (
  id serial PRIMARY KEY,
  name VARCHAR(255),
  stage_id integer
);

CREATE TABLE document_change (
  id serial PRIMARY KEY,
  document_id integer,
  imployee_id integer,
  date_ date,
  name VARCHAR(255)
);

