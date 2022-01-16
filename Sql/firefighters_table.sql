CREATE TABLE firefighters
(
    id serial primary key,
    email        varchar(50)  not null,
    firstname    varchar(100) not null,
    lastname     varchar(100) not null,
    passwordhash varchar(200) not null,
    firestation  varchar(50)  not null
);