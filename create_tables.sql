/* document status of images as they are edited */

CREATE TABLE fotos (
    img_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    path        TEXT,
    name        TEXT,
    bytes       INTEGER,
    dt_taken    TEXT,
    dt_created  TEXT,
    camera      TEXT,
    lens        TEXT,
    lat         REAL,
    lon         REAL,
    img_size    TEXT,
    duration    TEXT,
    md5         TEXT
);

CREATE TABLE notes (
    note_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    category    TEXT,
    comment     TEXT,
    img_id      INTEGER,
    note_dt     TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (img_id) REFERENCES fotos(img_id)
);

-- action/status use CHECK for now as a fixed vocabulary; may become lookup
-- tables later if the set of values needs to grow without editing this schema.
CREATE TABLE actions (
    action_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    action      TEXT CHECK(action IN ('mv','delete','rotate','resize','crop','edit','other')),
    request_dt  TEXT DEFAULT (datetime('now')),
    status_dt   TEXT,
    status      TEXT CHECK(status IN ('done','pending','failed')) DEFAULT 'pending',
    img_id      INTEGER,
    FOREIGN KEY (img_id) REFERENCES fotos(img_id)
);

CREATE INDEX idx_notes_img_id   ON notes(img_id);
CREATE INDEX idx_actions_img_id ON actions(img_id);
