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










begin tran

declare @src_node int = 134937; -- c:\users 269872,302911
declare @dest_node int = 218822; -- c:\windows\backup 303069 303070
declare @root_node int = 0;

declare @offset int;


---- step 1, detect scope (smallest parent node)
select top 1 @root_node = R.ID
from demo3.DIRINFO R, demo3.DIRINFO S, demo3.DIRINFO D
where 
	S.ID = @src_node and D.ID = @dest_node and
	R.LEFT_INDEX < S.LEFT_INDEX and R.RIGHT_INDEX > S.RIGHT_INDEX and 
	R.LEFT_INDEX < D.LEFT_INDEX and R.RIGHT_INDEX > D.RIGHT_INDEX
order by R.LEFT_INDEX desc
--select * from demo3.DIRINFO where ID = @root_node;


-- under (1,437638), move (269872,302911) -> (303069,303070)

-- step 2, move src to temp area
set @offset = 0 - 302911;
update demo3.DIRINFO
set LEFT_INDEX = LEFT_INDEX - @offset,
	RIGHT_INDEX = RIGHT_INDEX - @offset
where LEFT_INDEX between 269871 and 302912


-- step 3, allocate space
set @offset = 302911-269872+1;
update demo3.DIRINFO
set LEFT_INDEX = LEFT_INDEX - @offset
where LEFT_INDEX between 269872 and 303069
update demo3.DIRINFO
set RIGHT_INDEX = RIGHT_INDEX - @offset
where RIGHT_INDEX between 269872 and 303069



-- step 4, move all nodes in temp area to allocated space
set @offset = 303070
update demo3.DIRINFO
set LEFT_INDEX = LEFT_INDEX + @offset,
	RIGHT_INDEX = RIGHT_INDEX + @offset
where LEFT_INDEX < 0


--select * 
--from demo3.DIRINFO P inner join demo3.DIRINFO C on C.LEFT_INDEX between P.LEFT_INDEX and P.RIGHT_INDEX
--where P.ID = @root_node

rollback




------------------------------------------------------------------

begin tran

delete demo3.FILEINFO where DIR_ID in (
	select ID from demo3.DIRINFO where LEFT_INDEX >= 270029 and LEFT_INDEX <= 303070
)

delete demo3.DIRINFO where LEFT_INDEX > 270029 and LEFT_INDEX < 303070

update demo3.DIRINFO set RIGHT_INDEX = LEFT_INDEX + 1 where ID = 218825;
update demo3.DIRINFO set LEFT_INDEX = LEFT_INDEX - (303070-270029-1) where LEFT_INDEX > 270030;
update demo3.DIRINFO set RIGHT_INDEX = RIGHT_INDEX - (303070-270029-1) where RIGHT_INDEX > 270030;

rollback

select * from demo3.DIRINFO where LEFT_INDEX > 270029
select * from demo3.DIRINFO where ID = 218825

declare @root int = 218825; -- c:\windows\backup 270029 ~ 303070
select C.*
from demo3.DIRINFO C inner join demo3.DIRINFO P on C.LEFT_INDEX between P.LEFT_INDEX and P.RIGHT_INDEX
where P.ID = @root and C.ID <> @root
and not exists
(
  select *
  from demo3.DIRINFO M
  where M.LEFT_INDEX between P.LEFT_INDEX and P.RIGHT_INDEX
    and C.LEFT_INDEX between M.LEFT_INDEX and M.RIGHT_INDEX
	and M.ID <> P.ID 
	and M.ID <> C.ID
)
