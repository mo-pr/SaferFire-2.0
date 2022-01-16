CREATE TABLE guestUser
(
    id serial primary key,
    email varchar(50) not null,
    username varchar(100) not null,
    passwordHash varchar(200) not null,
    yearOfBirth date
);