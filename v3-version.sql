begin;

alter table Members
    alter column phone type varchar(20);

alter table Books
    add column publisher varchar(100);

alter table Borrowing
    ADD COLUMN fine_amount NUMERIC(10, 2) DEFAULT 0;

alter table Books
    add constraint check_published_date check (published_date <= CURRENT_DATE);

alter table Members
    add constraint check_email_format check (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');

commit;

-- rollback

begin;

alter table Members
    alter column phone type varchar(15);

alter table Books
    drop column if exists publisher;

alter table Borrowing
    drop column if exists fine_amount;

alter table Books
    drop constraint if exists check_published_date;

alter table Members
    drop constraint if exists check_email_format;

commit;