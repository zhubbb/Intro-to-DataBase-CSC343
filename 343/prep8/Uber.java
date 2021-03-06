import java.sql.*;
import java.io.*;
import org.postgresql.geometric.PGpoint;
class Uber {
	
    public static void main(String args[]) throws IOException {
        String url;
        Connection conn;
        PreparedStatement pStatement;
        ResultSet rs;
        String queryString;

        try {
            Class.forName("org.postgresql.Driver");
        }
        catch (ClassNotFoundException e) {
            System.out.println("Failed to find the JDBC driver");
        }

        try {
            // In this try block, you should
            // 1) Connect to the database and set the search path
            // 2) Prompt the user for the name of a client
            // 3) Make the appropriate database query string
            //    (use the '?' placeholder!!)
            // 4) Output the results
            // 5) Close the connection

            // NOTE: We didn't cover this in lecture, but you'll need to
            // execute a "SET search_path TO uber" statement before
            // executing any queries. Use the following code snippet to do so:
            //
            // queryString = "SET search_path TO uber";
            // pStatement = conn.prepareStatement(queryString);
            // pStatement.execute();

            // YOUR CODE GOES HERE



            url = "jdbc:postgresql://localhost:5432/csc343h-c6zhangx";
            conn = DriverManager.getConnection(url, "c6zhangx", "");

            Statement stat = conn.createStatement();
            String query = "set search_path to uber";
            stat.execute(query);

            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
            System.out.println("Enter the surname of a client. ");
            String surname = br.readLine();
            System.out.println("Enter the first name of a client. ");
            String firstname = br.readLine();
		
	  			

				PGpoint a = new PGpoint();
				PGpoint b = new PGpoint();
a.x=0;
a.y=0;
b.x=100;
b.y=100;
Timestamp t= new Timestamp(1000,0,0,0,0,0,0);

				String query1 = "INSERT INTO available VALUES (?,?,?)";
			PreparedStatement ps1 = conn.prepareStatement(query1);
			ps1.setInt(1, 5);
         ps1.setTimestamp(2, t);
 			ps1.setObject(3, a);
			ps1.executeUpdate();

            queryString = "select distinct (Driver.surname||(' ')||Driver.firstname) as name from Driver,Client,Dispatch,Request where Client.surname = ? and Client.firstname = ? and Client.client_id = Request.client_id and Request.request_id = Dispatch.request_id and Driver.driver_id = Dispatch.driver_id";

            PreparedStatement ps = conn.prepareStatement(queryString);
            ps.setString(1, surname);
            ps.setString(2, firstname);
            rs = ps.executeQuery();

            // Iterate through the result set and report on each tuple.
	    System.out.println("The result is :");
            while (rs.next()) {
                String name = rs.getString("name");
                System.out.println(name);
            }
				






        }
        catch (SQLException se) {
            System.err.println("SQL Exception." +
                    "<Message>: " + se.getMessage());
        }
    }
}
