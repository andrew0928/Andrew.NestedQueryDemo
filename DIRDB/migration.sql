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






--
-- migration from [dbo] to [demo2]
--
truncate table demo2.FILEINFO;
delete demo2.FILEINFO;
delete demo2.DIRINFO;


SET IDENTITY_INSERT demo2.DIRINFO ON;

insert into demo2.DIRINFO (ID, NAME, ID01, ID02, ID03, ID04, ID05, ID06, ID07, ID08, ID09, ID10, ID11, ID12, ID13, ID14, ID15, ID16, ID17, ID18, ID19, ID20)
select ID, NAME, PATH1, PATH2, PATH3, PATH4, PATH5, PATH6, PATH7, PATH8, PATH9, PATH10, PATH11, PATH12, PATH13, PATH14, PATH15, PATH16, PATH17, PATH18, PATH19, PATH20
from dbo.DIRINFO;

SET IDENTITY_INSERT demo2.DIRINFO OFF;

insert into demo2.FILEINFO select ID, DIR_ID, FILE_NAME as NAME, FILE_EXT as EXT, FILE_SIZE as SIZE from dbo.FILEINFO;



--
-- migration from [dbo] to [demo3]
--
truncate table demo3.FILEINFO;
delete demo3.FILEINFO;
delete demo3.DIRINFO;


SET IDENTITY_INSERT demo3.DIRINFO ON;
insert into demo3.DIRINFO (ID, NAME, LEFT_INDEX, RIGHT_INDEX) select ID, NAME, LEFT_INDEX, RIGHT_INDEX from dbo.DIRINFO;
SET IDENTITY_INSERT demo3.DIRINFO OFF;

insert into demo3.FILEINFO select ID, DIR_ID, FILE_NAME as NAME, FILE_EXT as EXT, FILE_SIZE as SIZE from dbo.FILEINFO;


