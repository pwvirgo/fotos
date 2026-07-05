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

drop view if exists actions;
create view actions as 
	select f.id, f.path, f.name, n.action, n.category, n.title 
		from fotos as f
		join  notes as n
		on f.id = n.fotos_id; 

select * from xxx limit 6;


