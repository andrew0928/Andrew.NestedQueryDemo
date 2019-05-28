-- dir c:\windows
select * 
from demo2.DIRINFO
where ID02 = 151535 and ID03 is NULL

-- dir /s c:\windows
select * 
from demo2.DIRINFO
where ID02 = 151535 

-- dir c:\windows\*
select *
from demo2.FILEINFO
where DIR_ID = 151535


-- format dir c:\windows
select * from
(
	select '<DIR>' as type, name, NULL as size from demo2.DIRINFO where ID02 = 151535 and ID03 is NULL
	union
	select '' as type, NAME as name, SIZE as size from demo2.FILEINFO where DIR_ID = 151535
) IX order by name asc





-- dir /s c:\windows\system32\*.ini
select F.NAME, F.SIZE
from demo2.FILEINFO F inner join demo2.DIRINFO D on F.DIR_ID = D.ID
where F.EXT = '.ini' and D.ID03 = 189039


-- cd c:\windows
-- mkdir backup
insert demo2.DIRINFO (NAME, ID01, ID02) values ('backup', 1, 151535)
select @@identity


-- move c:\users c:\windows\backup
update demo2.DIRINFO
set
	ID20 = ID19,
	ID19 = ID18,
	ID18 = ID17,
	ID17 = ID16,
	ID16 = ID15,
	ID15 = ID14,
	ID14 = ID13,
	ID13 = ID12,
	ID12 = ID11,
	ID11 = ID10,
	ID10 = ID09,
	ID09 = ID08,
	ID08 = ID07,
	ID07 = ID06,
	ID06 = ID05,
	ID05 = ID04,
	ID04 = ID03,	-- 以上為 shift right
	ID03 = 218818,	-- ID03 => c:\windows\backup
	ID02 = 151535,	-- ID02 => c:\windows
	ID01 = 1		-- ID01 => c:\
where ID02 = 134937 -- c:\users




-- del /s c:\windows\backup (218818)

delete demo2.FILEINFO where DIR_ID in (select ID from demo2.DIRINFO where ID03 = 218818)
delete demo2.DIRINFO where ID03 = 218818 

select * from demo2.DIRINFO where ID03 = 218818