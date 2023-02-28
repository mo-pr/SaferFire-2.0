CREATE TABLE saferfireusers
(
    id serial primary key,
    email        varchar(100)  not null,
    passwordhash varchar(200) not null,
    role        varchar(50) not null,
    firestation  varchar(50)  not null
);
