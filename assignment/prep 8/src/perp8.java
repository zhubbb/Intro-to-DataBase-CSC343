import java.sql.*;
import java.io.*;

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

            queryString = "select distinct (driver.surname||(' ')||driver.firstname) as name " +
                    "from Driver,Client,Dispatch,Request " +
                    "where client.surname = ? " +
                    "and client.firstname = ? " +
                    "and client.client_id=request.client_id " +
                    "and request.request_id= Dispatch.request_id ";
            PreparedStatement ps = conn.prepareStatement(queryString);
            ps.setString(1, surname);
            ps.setString(2, firstname);
            rs = ps.executeQuery();

            // Iterate through the result set and report on each tuple.
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