-- # People
-- Basic table for storing people. Ensure reasonable lengths for names.
-- Date of birth must be YYYY-MM-DD format
-- Content lenth implies it is to be used for optional long form prose about the person (self-documenting).

create table "people" (
    "id" integer primary key,
    "first_name" text not null check(length("first_name") <= 50),
    "last_name" text not null check(length("last_name") <= 50),
    "date_of_birth" text check ("date_of_birth" LIKE '____-__-__'),
    "content" text check(length("notes") <= 20000)
) strict;


-- # People Contacts
-- Type can only be 'phone' or 'email'. Ensure unique phone or email per person (indexes help ensure this).
-- Only accept integers for phone, 10-15 digits in length.
-- Use application logic for further validation and formatting.

CREATE TABLE "people_contacts" (
    "id" INTEGER PRIMARY KEY,
    "person_id" INTEGER NOT NULL,
    "type" TEXT NOT NULL CHECK ("type" IN ('phone', 'email')),
    "value" TEXT NOT NULL,
    "primary" INTEGER CHECK ("primary" IN (NULL, 1)),
    UNIQUE("person_id", "type", "value"),
    CHECK(
        ("type" = 'phone' AND "value" = CAST("value" AS INTEGER) AND LENGTH("value") BETWEEN 10 AND 15) OR 
        ("type" = 'email' AND "value" LIKE '%@%')
    ),
    FOREIGN KEY("person_id") REFERENCES "people"("id")
) STRICT;

CREATE UNIQUE INDEX idx_primary_phone ON people_contacts(person_id, "primary") WHERE "type" = 'phone' AND "primary" IS NOT NULL;
CREATE UNIQUE INDEX idx_primary_email ON people_contacts(person_id, "primary") WHERE "type" = 'email' AND "primary" IS NOT NULL;
