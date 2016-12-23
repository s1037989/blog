-- 1 up
create table if not exists posts (
  id    serial primary key,
  title text,
  body  text
);
create table if not exists users (
  id    serial primary key,
  email text,
  name  text
);

-- 1 down
drop table if exists posts;
drop table if exists users;
