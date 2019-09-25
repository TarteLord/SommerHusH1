using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace Sommerhus.Database
{
    static class SQL
    {
        // Lauges Connection string:
        // private static string ConnectionString = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SydvestDB;Data Source=localhost";

        private static string ConnectionString = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SydvestDB;Data Source=localhost";

        
        public static bool SQLConnectionOK()
        {

            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                try
                {
                    con.Open();
                    return true;
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                    return false;
                }
            }
        }


        public static void insert(string sql)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.ExecuteNonQuery();
            }
        }

        public static DataTable ReadTable(string sql)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                DataTable records = new DataTable();

                //Create new DataAdapter
                using (SqlDataAdapter a = new SqlDataAdapter(sql, con))
                {
                    //Use DataAdapter to fill DataTable records
                    con.Open();
                    a.Fill(records);
                }

                return records;
            }
        }

        public static void DataReader()
        {
            Console.WriteLine("DataReader");
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("Select * from Kunder", con);

                SqlDataReader reader = cmd.ExecuteReader();
                //Er der rækker?
                Console.WriteLine(reader.HasRows);

                while (reader.Read())
                {
                    int id = reader.GetInt32(0);
                    string navn = reader.GetString(1);
                    string adr = reader.GetString(2);
                    int alder = reader.GetInt32(3);

                    Console.WriteLine($"Id: {id} navn: {navn} adresse: {adr} - alder: {alder}");
                }

            }
        }

        public static List<string> getListFromSQL(string sql)
        {
            List<string> list = new List<string>();

            SqlConnection conn = new SqlConnection(ConnectionString);
            conn.Open();
            //string query = "SELECT ID FROM Cars WHERE custID = " ;
            SqlCommand cmd = new SqlCommand(sql, conn);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    list.Add(reader.GetString(0));
                }
            }

            conn.Close();
            return list;
        }
    }
}
