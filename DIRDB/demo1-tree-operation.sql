/*
1. 模擬 dir c:\windows 的結果，列出 c:\windows 下的目錄與檔案清單，統計檔案的大小
1. 模擬 dir /s /b c:\windows\*.dll，找出所有位於 c:\windows 目錄下 (包含子目錄) 所有副檔名為 .dll 的檔案清單
1. 模擬 move c:\windows\system32 c:\windows\temp\system32
1. 模擬 rm /s /q c:\windows\system32 (叔叔有練過，好孩子不要學)
1. 模擬 mkdir c:\windows\backup
*/


--
-- 1. 模擬 dir c:\windows 的結果，列出 c:\windows 下的目錄與檔案清單，統計檔案的大小
--

declare @root int;
select @root = D2.ID
from demo1.DIRINFO D1 inner join demo1.DIRINFO D2 on D1.ID = D2.PARENT_ID 
where D1.NAME = 'c:\' and D2.NAME = 'windows'

-- list DIR
select NAME from demo1.DIRINFO where PARENT_ID = @root

-- list FILE
select NAME, SIZE from demo1.FILEINFO where DIR_ID = @root


-- formatting output
select * from
(
	select '<DIR>' as type, name, NULL as size from demo1.DIRINFO where PARENT_ID = @root
	union
	select '' as type, NAME as name, SIZE as size from demo1.FILEINFO where DIR_ID = @root
) IX
order by name asc


--
-- 1. 模擬 dir /s /b c:\windows\*.dll，找出所有位於 c:\windows 目錄下 (包含子目錄) 所有副檔名為 .dll 的檔案清單
--


declare @root int;

select @root = D3.ID
from
	demo1.DIRINFO D1 inner join 
	demo1.DIRINFO D2 on D1.ID = D2.PARENT_ID inner join
	demo1.DIRINFO D3 on D2.ID = D3.PARENT_ID

where D1.NAME = 'c:\' and D2.NAME = 'windows' and D3.NAME = 'system32'


;with DIR_CTE(ID, NAME, FULLNAME) as
(
	select ID, NAME, cast('./' + NAME as ntext)
	from demo1.DIRINFO
	where PARENT_ID = @root

	union all

	select D1.ID, D1.NAME, cast(concat(D2.FULLNAME, '/', D1.NAME) as ntext)
	from demo1.DIRINFO D1 inner join DIR_CTE D2 on D1.PARENT_ID = D2.ID
)


select concat(D.FULLNAME, '/', F.NAME) as NAME, F.SIZE
from DIR_CTE D inner join demo1.FILEINFO F on D.ID = F.DIR_ID
where F.EXT = '.ini'








--
-- mkdir
--


declare @root int;

-- step 1, 找出 c:\windows 的 ID
select @root = D2.ID
from
	demo1.DIRINFO D1 inner join 
	demo1.DIRINFO D2 on D1.ID = D2.PARENT_ID 
where D1.NAME = 'c:\' and D2.NAME = 'windows' 


-- step 2, 在 c:\windows 下新增子目錄 backup
begin tran
insert demo1.DIRINFO (PARENT_ID, NAME) values (@root, 'backup');
select @@identity

select * from demo1.DIRINFO where PARENT_ID = @root order by NAME asc
rollback




--
-- move
--


