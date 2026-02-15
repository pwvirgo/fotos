CREATE TABLE fotos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
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

CREATE TABLE actions (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   foto_id INTEGER NOT NULL,
   act		TEXT,
   dt_act	TEXT,
   note		TEXT,
   FOREIGN KEY (foto_id) REFERENCES fotos(id)
);

