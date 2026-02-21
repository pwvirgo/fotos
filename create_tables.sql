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

drop view if exists votos;
create view votos as
    select f.id, substr(f.path,43,99), f.name, f.dt_taken,
        f.dt_created, f.camera, f.lens, f.lat, f.lon, f.img_size,
        f.duration
    from fotos f;


CREATE TABLE actions (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   foto_id INTEGER NOT NULL,
   act		TEXT,
   dt_act	TEXT,
   note		TEXT,
   FOREIGN KEY (foto_id) REFERENCES fotos(id)
);

