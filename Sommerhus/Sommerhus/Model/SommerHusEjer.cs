using System;

public class Sommerhusejer
{
	public Sommerhusejer()
	{

        DataTable currentTable = SQL.ReadTable("SELECT * FROM Ejer");

        DataRow row = currentTable.AsEnumerable().SingleOrDefault(r => r.Field<int>("EjerID") == sqlIndex);

        Console.WriteLine(row["EjerID"]);

    }
}
