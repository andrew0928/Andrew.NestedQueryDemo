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
select @root = ID from demo1.DIRINFO where PARENT_ID = 1 and name = 'windows'

select * from
(
	select '<DIR>' as type, NULL as size, name from demo1.DIRINFO where PARENT_ID = @root
	union
	select '' as type, Size as size, NAME as name from demo1.FILEINFO where DIR_ID = @root
) F
order by name asc


--
-- 1. 模擬 dir /s /b c:\windows\*.dll，找出所有位於 c:\windows 目錄下 (包含子目錄) 所有副檔名為 .dll 的檔案清單
--