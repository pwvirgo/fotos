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
) order by md5, name limit 15;