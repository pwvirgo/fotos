-- 81,312 files with duplicate MD5 hashes


SELECT SUM(FILE_COUNT)
FROM (
    SELECT COUNT(*) AS FILE_COUNT
    FROM fotos
    group by MD5
    having COUNT(*) > 1
)


select path, name, bytes, img_size, MD5
from fotos
where MD5 in (
    select MD5
    from fotos
    group by MD5
    having COUNT(*) > 1
) order by md5, path, name limit 15;

SELECT path, name, bytes, img_size, MD5
FROM fotos
WHERE MD5 IN (
    SELECT MD5
    FROM fotos
    GROUP BY MD5
    HAVING COUNT(*) > 1 
       AND SUM(CASE WHEN path LIKE '%Dropbox%' THEN 1 ELSE 0 END) > 0
) 
ORDER BY MD5, path, name;

SELECT path, name
FROM fotos
WHERE MD5 IN (
    SELECT MD5
    FROM fotos
    GROUP BY MD5
    HAVING COUNT(*) > 1 
       AND SUM(CASE WHEN path LIKE '%Dropbox%' THEN 1 ELSE 0 END) > 0
) 
ORDER BY MD5, path, name ;
