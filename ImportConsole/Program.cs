using System;
using System.Data.SqlClient;
using Dapper;
using System.IO;
using System.Text;
using System.Diagnostics;

namespace ImportConsole
{
    public class ProcessContext
    {
        public int LevelIndex = 0;
        public int TravelIndex = 0;
        public long[] PATHIDs = new long[1+20];
        public DirectoryInfo CurrentDirectoryInfo = new DirectoryInfo(@"c:\");

        //
        // for process statistics
        //
        public int MaxLevel = 0;
        public int TotalFilesCount = 0;
        public int TotalDirsCount = 0;
        public long TotalFileSize = 0;
        public int MaxFilesCountInOneDir = 0;
        public Stopwatch ScanTimer = new Stopwatch();
    }

    class Program
    {
        static SqlConnection _conn = null;


        static void Main(string[] args)
        {
            _conn = new SqlConnection("Data Source=.;User ID=sa;Password=1qaz@WSX3edc;Connect Timeout=30;Encrypt=False;TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False;Database=DIRDB;");
            _conn.Open();


            _conn.Execute("truncate table [FILEINFO];");
            _conn.Execute("truncate table [DIRINFO];");
            //_conn.Execute("delete [DIRINFO];");


            ProcessContext context = new ProcessContext()
            {
                //CurrentDirectoryInfo = new DirectoryInfo(@"c:\CodeWork\demo\")
            };
            context.PATHIDs[0] = 0;
            context.ScanTimer.Restart();
            ProcessFolder(context); //, dirTW, fileTW);
            context.ScanTimer.Stop();


            Console.WriteLine($"-------------------------------------------------------------------");
            Console.WriteLine($"- Total Dir(s):  {context.TotalDirsCount}");
            Console.WriteLine($"- Total File(s): {context.TotalFilesCount}");
            Console.WriteLine($"- Total File Size: {context.TotalFileSize / 1024 / 1024} MB");
            Console.WriteLine($"- Max Dir Level: {context.MaxLevel}");
            Console.WriteLine($"- Max Files In One Dir: {context.MaxFilesCountInOneDir}");
            Console.WriteLine($"- Total Scan Time: {context.ScanTimer.Elapsed.TotalSeconds} sec. (FPS: {context.TotalFilesCount / context.ScanTimer.Elapsed.TotalSeconds} files/sec)");
        }

        static long? ZeroToNULL(long value)
        {
            if (value == 0) return null;
            return value;
        }

        //static bool ProcessFolder(int level, long parentDirID, DirectoryInfo root) //, TextWriter dirTW, TextWriter fileTW)
        static bool ProcessFolder(ProcessContext context)
        {
            context.TravelIndex++;
            //int level = context.LevelIndex;
            //long parentDirID = context.PATHIDs[context.LevelIndex];
            //DirectoryInfo root = context.CurrentDirectoryInfo;



            Console.WriteLine($"process: {context.CurrentDirectoryInfo.FullName} ...");

            context.TotalDirsCount++;
            context.MaxLevel = Math.Max(context.MaxLevel, context.LevelIndex);
            int rootid = _conn.ExecuteScalar<int>(
@"
insert [dbo].[DIRINFO] (
    PARENT_ID, 
    FULLNAME, 
    NAME,

    LEVEL_INDEX,
    LEFT_INDEX,


    PATH1,
    PATH2,
    PATH3,
    PATH4,
    PATH5,
    PATH6,
    PATH7,
    PATH8,
    PATH9,
    PATH10,
    PATH11,
    PATH12,
    PATH13,
    PATH14,
    PATH15,
    PATH16,
    PATH17,
    PATH18,
    PATH19,
    PATH20
) values (
    @PARENT_ID, 
    @FULLNAME, 
    @NAME,

    @LEVEL,
    @LEFT,

    @PATH1,
    @PATH2,
    @PATH3,
    @PATH4,
    @PATH5,
    @PATH6,
    @PATH7,
    @PATH8,
    @PATH9,
    @PATH10,
    @PATH11,
    @PATH12,
    @PATH13,
    @PATH14,
    @PATH15,
    @PATH16,
    @PATH17,
    @PATH18,
    @PATH19,
    @PATH20
); select @@identity;",
                new
                {
                    PARENT_ID = context.PATHIDs[context.LevelIndex],
                    FULLNAME = context.CurrentDirectoryInfo.FullName,
                    NAME = context.CurrentDirectoryInfo.Name,

                    LEVEL = context.LevelIndex,
                    LEFT = context.TravelIndex,

                    PATH1 = ZeroToNULL(context.PATHIDs[1]),
                    PATH2 = ZeroToNULL(context.PATHIDs[2]),
                    PATH3 = ZeroToNULL(context.PATHIDs[3]),
                    PATH4 = ZeroToNULL(context.PATHIDs[4]),
                    PATH5 = ZeroToNULL(context.PATHIDs[5]),
                    PATH6 = ZeroToNULL(context.PATHIDs[6]),
                    PATH7 = ZeroToNULL(context.PATHIDs[7]),
                    PATH8 = ZeroToNULL(context.PATHIDs[8]),
                    PATH9 = ZeroToNULL(context.PATHIDs[9]),
                    PATH10 = ZeroToNULL(context.PATHIDs[10]),
                    PATH11 = ZeroToNULL(context.PATHIDs[11]),
                    PATH12 = ZeroToNULL(context.PATHIDs[12]),
                    PATH13 = ZeroToNULL(context.PATHIDs[13]),
                    PATH14 = ZeroToNULL(context.PATHIDs[14]),
                    PATH15 = ZeroToNULL(context.PATHIDs[15]),
                    PATH16 = ZeroToNULL(context.PATHIDs[16]),
                    PATH17 = ZeroToNULL(context.PATHIDs[17]),
                    PATH18 = ZeroToNULL(context.PATHIDs[18]),
                    PATH19 = ZeroToNULL(context.PATHIDs[19]),
                    PATH20 = ZeroToNULL(context.PATHIDs[20]),
                });


            FileInfo[] files = new FileInfo[0];
            try
            {
                files = context.CurrentDirectoryInfo.GetFiles();
            }
            catch
            {
                // no permission
                Console.WriteLine("No permission (GetFiles)");
            }

            foreach (FileInfo subfile in files)
            {
                _conn.ExecuteScalar<int>(
@"
insert [dbo].[FILEINFO] (
    DIR_ID, 
    FULLNAME, 
    FILE_NAME, 
    FILE_EXT, 
    FILE_SIZE
) values (
    @DIR_ID, 
    @FULLNAME, 
    @FILE_NAME, 
    @FILE_EXT, 
    @FILE_SIZE
); 
select @@identity;",
                    new {
                        DIR_ID = rootid,
                        FULLNAME = subfile.FullName,
                        FILE_NAME = subfile.Name,
                        FILE_EXT = subfile.Extension,
                        FILE_SIZE = subfile.Length
                    });
                //total_files++;
                //total_size += subfile.Length;

                context.TotalFilesCount++;
                context.TotalFileSize += subfile.Length;
            }
            context.MaxFilesCountInOneDir = Math.Max(context.MaxFilesCountInOneDir, files.Length);
            files = null;


            DirectoryInfo[] dirs = new DirectoryInfo[0];
            try
            {
                dirs = context.CurrentDirectoryInfo.GetDirectories();
            }
            catch
            {
                // no permission
                Console.WriteLine("No permission (GetDirectories)");
            }


            foreach (DirectoryInfo subdir in dirs)
            {
                if (subdir.Attributes.HasFlag(FileAttributes.ReparsePoint)) continue; // bypass symbol link


                context.LevelIndex++;
                context.PATHIDs[context.LevelIndex] = rootid;
                context.CurrentDirectoryInfo = subdir;

                ProcessFolder(context);

                context.PATHIDs[context.LevelIndex] = 0;
                context.LevelIndex--;
            }
            dirs = null;



            context.TravelIndex++;
            _conn.Execute(
                @"update [dbo].[DIRINFO] set RIGHT_INDEX = @RIGHT where ID = @ID;",
                new
                {
                    ID = rootid,
                    RIGHT = context.TravelIndex
                });

            return true;
        }

        //static long total_dirs = 0;
        //static long total_files = 0;
        //static long total_size = 0;
        //static int max_levels = 0;
        //static Stopwatch total_scan_timer = new Stopwatch();
    }
}
