using System;
using System.Data.SqlClient;
using Dapper;
using System.IO;
using System.Text;
using System.Diagnostics;

namespace ImportConsole
{
    class Program
    {
        static SqlConnection _conn = null;


        static void Main(string[] args)
        {
            _conn = new SqlConnection("Data Source=172.21.205.3;User ID=sa;Password=1qaz@WSX3edc;Connect Timeout=30;Encrypt=False;TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False;Database=DIRDB;");
            _conn.Open();


            _conn.Execute("truncate table [DIRINFO]; truncate table [FILEINFO];");


            //using (TextWriter dirTW = new StreamWriter("dirs.csv", false, Encoding.UTF8))
            //using (TextWriter fileTW = new StreamWriter("files.csv", false, Encoding.UTF8))
            {
                //DirectoryInfo rootDI = new DirectoryInfo(@"c:\windows\");

                //dirTW.WriteLine($"ID,PARENT_ID,FULLNAME,NAME");
                //fileTW.WriteLine($"ID,DIR_ID,FULLNAME,FILE_NAME,FILE_EXT,FILE_SIZE");
                total_scan_timer.Restart();
                ProcessFolder(1, 0, new DirectoryInfo(@"c:\")); //, dirTW, fileTW);
                total_scan_timer.Stop();
                //ProcessFolder(1, 0, new DirectoryInfo(@"c:\users\"), dirTW, fileTW);
                //ProcessFolder(1, 0, new DirectoryInfo(@"c:\"), dirTW, fileTW);
            }

            Console.WriteLine($"-------------------------------------------------------------------");
            Console.WriteLine($"- Total Dir(s):  {total_dirs}");
            Console.WriteLine($"- Total File(s): {total_files}");
            Console.WriteLine($"- Total File Size: {total_size / 1024 / 1024} MB");
            Console.WriteLine($"- Max Dir Level: {max_levels}");
            Console.WriteLine($"- Total Scan Time: {total_scan_timer.Elapsed.TotalSeconds} sec. (FPS: {total_files / total_scan_timer.Elapsed.TotalSeconds} files/sec)");
        }



        static bool ProcessFolder(int level, long parentDirID, DirectoryInfo root) //, TextWriter dirTW, TextWriter fileTW)
        {
            Console.WriteLine($"process: {root.FullName} ...");

            total_dirs++;
            if (level > max_levels) max_levels = level;
            //dirTW.Flush();
            //fileTW.Flush();

            //dirTW.WriteLine($"ID,FULLNAME,NAME");
            //fileTW.WriteLine($"ID,DIR_ID,FULLNAME,FILE_NAME,FILE_EXT,FILE_SIZE");

            //DirectoryInfo rootDI = new DirectoryInfo(root);

            //int rootid = DirIdGen();
            //dirTW.WriteLine($"{rootid},{parentDirID},{root.FullName},{root.Name}");
            int rootid = _conn.ExecuteScalar<int>(
                @"insert [dbo].[DIRINFO] (PARENT_ID, FULLNAME, NAME) values (@PARENT_ID, @FULLNAME, @NAME); select @@identity;",
                new
                {
                    PARENT_ID = parentDirID,
                    FULLNAME = root.FullName,
                    NAME = root.Name
                });

            try
            {
                foreach (FileInfo subfile in root.GetFiles())
                {
                    //fileTW.WriteLine($"{FileIdGen()},{rootid},{subfile.FullName},{subfile.Name},{subfile.Extension},{subfile.Length}");
                    _conn.ExecuteScalar<int>(
                        @"insert [dbo].[FILEINFO] (DIR_ID, FULLNAME, FILE_NAME, FILE_EXT, FILE_SIZE) values (@DIR_ID, @FULLNAME, @FILE_NAME, @FILE_EXT, @FILE_SIZE); select @@identity;",
                        new {
                            DIR_ID = rootid,
                            FULLNAME = subfile.FullName,
                            FILE_NAME = subfile.Name,
                            FILE_EXT = subfile.Extension,
                            FILE_SIZE = (int)subfile.Length
                        });
                    total_files++;
                    total_size += subfile.Length;
                }
            }
            catch
            {
                // no permission
            }

            try
            {
                foreach (DirectoryInfo subdir in root.GetDirectories())
                {
                    if (subdir.Attributes.HasFlag(FileAttributes.ReparsePoint)) continue; // bypass symbol link
                    ProcessFolder(level + 1, rootid, subdir); //, dirTW, fileTW);
                }
            }
            catch
            {
                // no permission
            }

            return true;
        }

        //private static int _dirid = 0;
        //static int DirIdGen()
        //{
        //    return _dirid++;
        //}

        //private static int _fileid = 0;
        //static int FileIdGen()
        //{
        //    return _fileid++;
        //}

        static long total_dirs = 0;
        static long total_files = 0;
        static long total_size = 0;
        static int max_levels = 0;
        static Stopwatch total_scan_timer = new Stopwatch();
    }
}
