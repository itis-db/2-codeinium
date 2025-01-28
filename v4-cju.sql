
insert into Authors (name, birth_date, biography)
values
    ('J.K. Rowling', '1965-07-31', 'British author, best known for the Harry Potter series.'),
    ('George Orwell', '1903-06-25', 'English novelist, essayist, journalist and critic.');

insert into Categories (name, description)
values
    ('Fantasy', 'Books with magical elements and mythical creatures'),
    ('Dystopian', 'Books set in dystopian futures, often exploring political themes.');


insert into Books (title, isbn, published_date, category_id)
values
    ('Harry Potter and the Sorcerer Stone', '9780747532699', '1997-06-26', 1),
    ('1984', '9780451524935', '1949-06-08', 2);


with CTE_Authors as (
    select a.author_id, a.name as author_name, b.book_id
    from Authors a
             inner join Books b on a.author_id = b.book_id
),
     CTE_Books as (
         select b.book_id, b.title, b.isbn, b.published_date, c.name as category_name
         from Books b
                  left join Categories c on b.category_id = c.category_id
     )

select b.title, b.isbn, b.published_date, b.category_name, a.author_name
from CTE_Books b
         inner join CTE_Authors a on a.book_id = b.book_id
union
select b.title, b.isbn, b.published_date, 'Unknown Author' AS author_name
from Books b
         left join Authors a on b.book_id = a.author_id
where a.author_id is null;


