Create Table MissionData
(
    id serial primary key,
    mission_number int,
    location varchar(100) not null,
    timestamp time not null,
    alert_level int not null,
    type_of_operation varchar(100) not null,
    fire_station varchar(100) not null
);
