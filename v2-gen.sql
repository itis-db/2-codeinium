truncate Borrowing, Booksauthors, Books, Authors, Categories, Members restart identity cascade;

insert into Authors (name, birth_date, biography)
select
    'Author_' || i,
    date '1980-01-01' + (random() * 25550)::int,
    'Biography of Author_' || i
from generate_series(1, 50) as i;

insert into Categories(name, description)
select
    'Category_' || i,
    'Description for Category_' || i
from generate_series(1, 10) as i;

insert into Books (title, isbn, published_date, category_id)
select
    'Book Title ' || i,
    'ISBN-' || (1000000000 + i),
    date '1980-01-01' + (random() * 15340)::int,
    (random() * 10 + 1)::int
from generate_series(1, 100) as i;

insert into Members (name, email, phone)
select
    'Member_' || i,
    'member_' || i || '@example.com',
    '123-456-789' || i
from generate_series(1, 50) as i;

insert into Borrowing (book_id, member_id, borrowed_date, due_date, returned_date)
select
    (random() * 100 + 1)::int,
    (random() * 50 + 1)::int,
    now() - (random() * 30 || ' days')::interval,
    now() + (random() * 30 || ' days')::interval,
    case when random() < 0.7 then NOW() - (random() * 10 || ' days')::interval else null end
from generate_series(1, 150) as i;

insert into booksauthors (book_id, author_id)
select
    (random() * 100 + 1)::int,
    (random() * 50 + 1)::int
from generate_series(1, 200) as i;