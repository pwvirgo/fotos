

select substr(path,20,70) as pathx, name, bytes, dt_created, md5
from fotos
where md5 in (
	select md5 from fotos
	where path like '%2021_imac%'  or path like '%ook2012%'
	group by md5
	having count(*) > 1)
order by md5, pathx, name
limit 30;

select substr(path,6,46) as pathx, count(*)
from fotos
where md5 in (
	select md5 from fotos
	where path like '%2021_imac%'  or path like '%ook2012%'
	group by md5
	having count(*) > 1)
group by pathx
order by pathx
limit 30;



