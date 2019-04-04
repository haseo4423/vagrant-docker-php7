CREATE ROLE postgre_user WITH LOGIN PASSWORD '7890';
CREATE DATABASE sample_database;
GRANT ALL PRIVILEGES ON DATABASE sample_database TO postgre_user;
