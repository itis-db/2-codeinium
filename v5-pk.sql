begin;

--для переноса данных можем создать временные таблицы
create table temp_authors as select * from Authors;
create table temp_categories as select * from  Categories;
create table temp_books as select * from  Books;
create table temp_members as select * from  Members;
create table temp_borrowing as select * from  Borrowing;
create table temp_booksauthors as select * from  BooksAuthors;

--дропаем старую таблицу, и тут же ее создаем и переносим данные из временной
--имя автора по сути уникально, будет использоваться как естествнный ключ
drop table if exists Authors cascade;
create table Authors (
    name varchar(100) primary key,
    birth_date date,
    biography text
);
insert into Authors (name, birth_date, biography)
select name, birth_date, biography from temp_authors;

-- название категории тоже уникально -> будет естестенным ключом
drop table if exists Categories cascade;
create table Categories (
    name varchar(100) primary key,
    description text
);
insert into Categories (name, description)
select name, description from temp_categories;

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
insert into Books (isbn, title, published_date, category_name)
select isbn, title, published_date, (select name from Categories where name = b.category_name)
from temp_books b;

-- почта тоже всегда уникальна
drop table if exists Members cascade;
CREATE TABLE Members (
    email varchar(100) primary key,
    name varchar(100) not null,
    phone varchar(15),
    registration_date timestamp default CURRENT_TIMESTAMP
);
insert into Members (email, name, phone, registration_date)
select email, name, phone, registration_date from temp_members;

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
INSERT INTO Borrowing (isbn, email, borrowed_date, due_date, returned_date)
select (select isbn from temp_books where isbn = b.isbn),
       (select email from temp_members where email = b.email),
       borrowed_date, due_date, returned_date
from temp_borrowing b;

-- та же история как с таблицей книг
drop table if exists BooksAuthors cascade;
create table BooksAuthors (
    isbn varchar(20) not null,
    author_name varchar(100) not null,
    primary key (isbn, author_name),
    foreign key (isbn) references Books(isbn) on delete cascade,
    foreign key (author_name) references Authors(name) on delete cascade
);
insert into BooksAuthors (isbn, author_name)
select (select isbn from temp_books where isbn = ba.isbn),
       (select name from temp_authors where name = ba.author_name)
from temp_booksauthors ba;

commit;

-- для отката изменения
-- drop table if exists Authors cascade;
-- drop table if exists Categories cascade;
-- drop table if exists Books cascade;
-- drop table if exists Members cascade;
-- drop table if exists Borrowing cascade;
-- drop table if exists BooksAuthors cascade;

-- восстановление всех данных всех таблиц
-- insert into Authors select * from temp_authors;
-- insert into Categories select * from temp_categories;
-- insert into Books select * from temp_books;
-- insert into Members select * from temp_members;
-- insert into Borrowing select * from temp_borrowing;
-- insert into BooksAuthors select * from temp_booksauthors;

-- дроп временных таблиц
-- drop table temp_authors;
-- drop table temp_categories;
-- drop table temp_books;
-- drop table temp_members;
-- drop table temp_borrowing;
-- drop table temp_booksauthors;

