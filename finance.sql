CREATE TABLE "invoices" (
    "id" INTEGER PRIMARY KEY,
    "person_id" INTEGER NOT NULL,
    "issue_date" TEXT NOT NULL CHECK("issue_date" LIKE '____-__-__'),
    "due_date" TEXT NOT NULL CHECK("due_date" LIKE '____-__-__'),
    "amount" REAL NOT NULL CHECK("amount" >= 0),
    "canceled" INTEGER DEFAULT 0 CHECK("cancelled" IN (0, 1)),
    FOREIGN KEY("person_id") REFERENCES "people"("id") ON UPDATE CASCADE ON DELETE CASCADE
) STRICT;

CREATE TABLE "payments" (
    "id" INTEGER PRIMARY KEY,
    "invoice_id" INTEGER NOT NULL,
    "date" TEXT NOT NULL CHECK("date" LIKE '____-__-__'),
    "amount" REAL NOT NULL CHECK("amount" >= 0),
    "method" TEXT NOT NULL CHECK("method" IN ('cash', 'card', 'bank_transfer', 'check', 'other')),
    FOREIGN KEY("invoice_id") REFERENCES "invoices"("id") ON UPDATE CASCADE ON DELETE CASCADE
) STRICT;
