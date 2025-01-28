begin;

--имя автора по сути уникально, будет использоваться как естествнный ключ
drop table if exists Authors cascade;
create table Authors (
    name varchar(100) primary key,
    birth_date date,
    biography text
);

-- название категории тоже уникально -> будет естестенным ключом
drop table if exists Categories cascade;
create table Categories (
    name varchar(100) primary key,
    description text
);

-- удаляю старую таблицу и создаю уже ее с естественным ключом
-- isbn международный книжный стандарт, уникальный номер кнеги, нам как раз подходит
drop table if exists Books cascade;
create table Books (
    isbn varchar(20) primary key,
    title varchar(255) not null,
    published_date date,
    category_name varchar(100),
    foreign key (category_name) references Categories(name) on delete set null
);

-- почта тоже всегда уникальна
drop table if exists Members cascade;
CREATE TABLE Members (
    email varchar(100) primary key,
    name varchar(100) not null,
    phone varchar(15),
    registration_date timestamp default CURRENT_TIMESTAMP
);

-- та же история как с таблицей книг
drop table if exists Borrowing cascade;
create table Borrowing (
    isbn varchar(20) not null,
    email varchar(100) not null,
    borrowed_date timestamp default CURRENT_TIMESTAMP,
    due_date timestamp,
    returned_date timestamp,
    primary key (isbn, email),
    foreign key (isbn) references Books(isbn) on delete cascade ,
    foreign key (email) references Members(email) on delete cascade
);

-- та же история как с таблицей книг
drop table if exists BooksAuthors cascade;
create table BooksAuthors (
    isbn varchar(20) not null,
    author_name varchar(100) not null,
    primary key (isbn, author_name),
    foreign key (isbn) references Books(isbn) on delete cascade,
    foreign key (author_name) references Authors(name) on delete cascade
);

commit;
