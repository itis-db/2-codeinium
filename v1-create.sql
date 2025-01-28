create table Authors
(
    author_id  serial primary key ,
    name       varchar(100) not null ,
    birth_date date,
    biography  text
);

create table Categories
(
    category_id serial primary key,
    name        varchar(100) unique not null,
    description text
);

create table Books
(
    book_id serial primary key ,
    title varchar(255) not null,
    isbn varchar(20) unique,
    published_date date,
    category_id int,
    foreign key (category_id) references Categories(category_id) on delete set null
);

create table Members
(
    member_id serial primary key,
    name varchar(100) not null,
    email varchar(100) unique not null ,
    phone varchar(15),
    registration_date timestamp default current_timestamp
);

create table Borrowing
(
    borrowing_id serial primary key,
    book_id int not null,
    member_id int not null,
    borrowed_date timestamp default current_timestamp,
    due_date timestamp,
    returned_date timestamp,
    foreign key (book_id) references Books(book_id) on delete cascade,
    foreign key (member_id) references Members(member_id) on delete cascade
);

create table BooksAuthors
(
    book_id int not null,
    author_id int not null,
    primary key (book_id, author_id),
    foreign key (book_id) references Books(book_id) on delete cascade,
    foreign key (author_id) references Authors(author_id) on delete cascade
);