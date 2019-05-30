select F.*
from demo3.DIRINFO C inner join demo3.FILEINFO F on C.ID = F.DIR_ID
where F.EXT = '.ini' and C.LEFT_INDEX between 378075 and 380740

select F.*
from demo3.DIRINFO C inner join demo3.FILEINFO F on C.ID = F.DIR_ID
where F.EXT = '.dll' and C.LEFT_INDEX between 303068 and 437609





select * from
(
	select '<DIR>' as type, name, NULL as size from demo3.DIRINFO where LEFT_INDEX between 303068 and 437609

	union

	select '' as type, F.NAME, F.SIZE
	from demo3.DIRINFO C inner join demo3.FILEINFO F on C.ID = F.DIR_ID
	where F.EXT = '.ini' and C.LEFT_INDEX between 303068 and 437609

) IX order by name asc




--begin tran
	declare @windows_left as int = 303068;
	declare @windows_right as int = 437609;

	-- step 1, 在 303068 騰出兩個位子，把所有 index > 303068 的數值都 +2
	update demo3.DIRINFO set RIGHT_INDEX = RIGHT_INDEX + 2 where RIGHT_INDEX > @windows_left;
	update demo3.DIRINFO set LEFT_INDEX = LEFT_INDEX + 2 where LEFT_INDEX > @windows_left;

	-- step 2, 空出的兩個 index 就保留給插入的新目錄 c:\windows\backup
	insert demo3.DIRINFO (NAME, LEFT_INDEX, RIGHT_INDEX) values ('backup', @windows_left + 1, @windows_left + 2);
	select @@identity;

	select * from demo3.DIRINFO where LEFT_INDEX > @windows_left;

--rollback











