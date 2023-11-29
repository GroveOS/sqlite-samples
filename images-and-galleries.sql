-- # Images
-- `media_path` ambigously allows reference for local file paths or remote object urls/ids (defers to application-level logic)
-- `caption` allows for short form description of image while `content` infers long form prose (self-documenting)
-- `content` at the end allows for faster search if large content is stored across many records
CREATE TABLE "images" (
    "id" INTEGER PRIMARY KEY,
    "title" TEXT NOT NULL CHECK(length("title") <= 100),
    "caption" TEXT CHECK(length("caption") <= 240),
    "media_path" TEXT NOT NULL,
    "created" TEXT DEFAULT CURRENT_TIMESTAMP,
    "updated" TEXT DEFAULT CURRENT_TIMESTAMP,
    "content" TEXT CHECK(length("content") <= 20000)
) STRICT;

-- # Galleries
-- `description` allows for short form description of image while `content` infers long form prose (self-documenting)
-- `content` at the end allows for faster search if large content is stored across many records
CREATE TABLE "galleries" (
    "id" INTEGER PRIMARY KEY,
    "title" TEXT NOT NULL CHECK(length("title") <= 100),
    "description" TEXT CHECK(length("description") <= 240),
    "created" TEXT DEFAULT CURRENT_TIMESTAMP,
    "updated" TEXT DEFAULT CURRENT_TIMESTAMP,
    "content" TEXT CHECK(length("content") <= 20000)
) STRICT;

-- # Gallery Images
-- Links images to their parent galleries
CREATE TABLE "gallery_images" (
    "id" INTEGER PRIMARY KEY,
    "image_id" INTEGER NOT NULL,
    "gallery_id" INTEGER NOT NULL,
    "created" TEXT DEFAULT CURRENT_TIMESTAMP,
    "updated" TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY("image_id") REFERENCES "images"("id") ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY("gallery_id") REFERENCES "galleries"("id") ON UPDATE CASCADE ON DELETE CASCADE
) STRICT;

-- # Triggers
-- Automatically updates the `updated` field on update
CREATE TRIGGER "update_images_updated" AFTER UPDATE ON "images" BEGIN UPDATE "images" SET "updated" = CURRENT_TIMESTAMP WHERE "id" = NEW."id"; END;
CREATE TRIGGER "update_galleries_updated" AFTER UPDATE ON "galleries" BEGIN UPDATE "galleries" SET "updated" = CURRENT_TIMESTAMP WHERE "id" = NEW."id"; END;
CREATE TRIGGER "update_image_galleries_updated" AFTER UPDATE ON "image_galleries" BEGIN UPDATE "image_galleries" SET "updated" = CURRENT_TIMESTAMP WHERE "image_id" = NEW."image_id" AND "gallery_id" = NEW."gallery_id"; END;
