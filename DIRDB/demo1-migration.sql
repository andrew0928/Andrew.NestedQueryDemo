--
-- migration from [dbo] to [demo1]
--
truncate table demo1.FILEINFO;
delete demo1.FILEINFO;
delete demo1.DIRINFO;


SET IDENTITY_INSERT demo1.DIRINFO ON;
insert into demo1.DIRINFO (ID, PARENT_ID, NAME) select ID, PARENT_ID, NAME from dbo.DIRINFO;
SET IDENTITY_INSERT demo1.DIRINFO OFF;

insert into demo1.FILEINFO select ID, DIR_ID, FILE_NAME as NAME, FILE_EXT as EXT, FILE_SIZE as SIZE from dbo.FILEINFO;
