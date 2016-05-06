create table if not exists item (
    id  integer not null primary key autoincrement,
    type    tinyint not null,
    title   varchar(255) not null,
    text    text not null,
    done    tinyint not null,
    modified_at  text not null
);
