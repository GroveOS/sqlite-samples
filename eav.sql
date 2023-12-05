-- # EAV Style Architecture
-- A flexible data storage method using the Entity-Attribute-Value model. 
-- It has some performance trade-offs due to less normalized data and more joins.
-- Indexes are implemented for performance optimization.

-- ## Templates Table
-- Defines the data structure with a title and
-- optional short description and detailed content.
CREATE TABLE "Templates" (
    "ID" INTEGER PRIMARY KEY AUTOINCREMENT,
    "Title" TEXT,
    "Description" TEXT CHECK (LENGTH("Description") <= 280),
    "Content" TEXT CHECK (LENGTH("Content") <= 10000)
);

-- ## Entities Table
-- Stores records, each linked to a template with a unique ID.
CREATE TABLE "Entities" (
    "ID" INTEGER PRIMARY KEY AUTOINCREMENT,
    "TemplateID" INTEGER,
    FOREIGN KEY ("TemplateID") REFERENCES "Templates"("ID")
);

-- ## Attributes Table
-- Associates data types with each template, including title,
-- type, and optional short description and detailed content.
CREATE TABLE "Attributes" (
    "ID" INTEGER PRIMARY KEY AUTOINCREMENT,
    "TemplateID" INTEGER,
    "Title" TEXT,
    "Type" TEXT CHECK ("Type" IN ('integer', 'text', 'blob')),
    "Required" INTEGER CHECK ("Required" IN (0, 1)),1).
    "Description" TEXT CHECK (LENGTH("Description") <= 280),
    "Content" TEXT CHECK (LENGTH("Content") <= 10000),
    FOREIGN KEY ("TemplateID") REFERENCES "Templates"("ID")
);

-- ## Values Tables (Integer, Text, Blob)
-- Stores actual data, linking values to entities and attributes.
CREATE TABLE "IntegerValues" (
    "ID" INTEGER PRIMARY KEY AUTOINCREMENT,
    "EntityID" INTEGER,
    "AttributeID" INTEGER,
    "Value" INTEGER,
    FOREIGN KEY ("EntityID") REFERENCES "Entities"("ID"),
    FOREIGN KEY ("AttributeID") REFERENCES "Attributes"("ID")
);

CREATE TABLE "TextValues" (
    "ID" INTEGER PRIMARY KEY AUTOINCREMENT,
    "EntityID" INTEGER,
    "AttributeID" INTEGER,
    "Value" TEXT,
    FOREIGN KEY ("EntityID") REFERENCES "Entities"("ID"),
    FOREIGN KEY ("AttributeID") REFERENCES "Attributes"("ID")
);

CREATE TABLE "BlobValues" (
    "EntityID" INTEGER,
    "AttributeID" INTEGER,
    "Value" BLOB,
    PRIMARY KEY ("EntityID", "AttributeID"),
    FOREIGN KEY ("EntityID") REFERENCES "Entities"("ID"),
    FOREIGN KEY ("AttributeID") REFERENCES "Attributes"("ID")
);

-- ## Indexes
-- Enhances query performance; optional but recommended.
CREATE INDEX "idx_integer_values" ON "IntegerValues" ("EntityID", "AttributeID");
CREATE INDEX "idx_text_values" ON "TextValues" ("EntityID", "AttributeID");
CREATE INDEX "idx_blob_values" ON "BlobValues" ("EntityID", "AttributeID");
