--
-- migration from [dbo] to [demo1]
--
truncate table demo1.FILEINFO;
delete demo1.FILEINFO;
delete demo1.DIRINFO;

insert into demo1.DIRINFO select ID, PARENT_ID, NAME from dbo.DIRINFO;
insert into demo1.FILEINFO select ID, DIR_ID, FILE_NAME as NAME, FILE_EXT as EXT, FILE_SIZE as SIZE from dbo.FILEINFO;