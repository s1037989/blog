-- 1 up
create table if not exists posts (
  id    serial primary key,
  title text,
  body  text
);
create table if not exists users (
  id    text primary key,
  email text,
  name  text
);
create table if not exists providers (
  id          text,
  provider_id text,
  provider    text,
  created     timestamptz not null default now(),
  PRIMARY KEY (id, provider_id, provider)
);

-- 1 down
drop table if exists posts;
drop table if exists users;
drop table if exists providers;
