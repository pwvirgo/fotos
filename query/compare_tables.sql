ATTACH DATABASE 'fotos.db' AS old;

SELECT  path, name, bytes, dt_taken, dt_created, camera,
        lens, lat, lon, img_size, duration, md5
FROM main.fotos
EXCEPT
SELECT  path, name, bytes, dt_taken, dt_created, camera,
        lens, lat, lon, img_size, duration, md5
FROM old.fotos;

SELECT  path, name, bytes, dt_taken, dt_created, camera,
        lens, lat, lon, img_size, duration, md5
FROM old.fotos
EXCEPT
SELECT  path, name, bytes, dt_taken, dt_created, camera,
        lens, lat, lon, img_size, duration, md5
FROM main.fotos;
