/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ybk.db;
/**
 * @author yongbam
 *
 */

// For use JDBC object in JSP must import java.sql package
import java.sql.*;

public class Manage {
    // DBMS url
    private final String url = "jdbc:mysql://127.0.0.1:3310/mydata";
    // user account
    private final String id = "yongbam";
    // user pass
    private final String pw = "1234K8765k";
    // DBMS Connection
    private Connection conn = null;
    // Query result
    private ResultSet rs = null;
    // for query statement
    private Statement stmt = null;
    private PreparedStatement pstmt=null;

    // parameters rule - query, sz(if value is string) or n(if value is integer), value, sz or n, value, ...
    public ResultSet ExecutePrepareQuery(final String szQueryString, String ... vars)
    {
        try 
        {   
            if(rs !=null && !rs.isClosed()) rs.close();
            if(pstmt!=null && !pstmt.isClosed()) pstmt.close();

            pstmt = conn.prepareStatement(szQueryString);
            
            // Check
            System.out.println("ExcutePrepareQuery values");
            for(int i=1, j=1; j<vars.length; ++i, j+=2)
            {	
                System.out.println(Integer.toString(j-1)+":"+vars[j-1]);
                System.out.println(Integer.toString(j)+":"+vars[j]);
            }

            for(int i=1, j=1; j<vars.length; ++i, j+=2)
            {
                if(vars[j-1].equals("sz"))
                    pstmt.setString(i, vars[j]);
                else if(vars[j-1].equals("n"))
                    pstmt.setInt(i, Integer.parseInt(vars[j]));
                else
                    throw new Exception("Incorrect use!!, use like ExecutePrepareQuery(query, sz or n, value, sz or n, value, ...)\n"
                            + "if value is string use \"sz\" and if integer use \"n\"\n");

            }

            boolean isUpdate = true;
            String[] str = szQueryString.split(" ");
            if(str[0].toUpperCase().equals("SELECT") )
                isUpdate=false;
            
            if(isUpdate)
            {
                pstmt.executeUpdate();
                pstmt.close();
                System.out.println("ExcutePrepqredQuery Successfully end");
                return null;
            }
            else
            {
                rs = pstmt.executeQuery();
//                pstmt.close();    // if close then rs also closed

                if(rs==null)
                    throw new Exception("Query Failed\n");
                
                return rs;
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }
    }

    public ResultSet ExecuteQuery(final String szQueryString)
    {
        try 
        {
            if(rs !=null && !rs.isClosed()) rs.close();
            if(stmt!=null && !stmt.isClosed()) stmt.close();
            
            stmt = conn.createStatement();
            
            boolean isUpdate = true;
            String[] str = szQueryString.split(" ");
            
            if(str[0].toUpperCase().equals("SELECT") )
                isUpdate=false;
            
            System.out.printf(szQueryString+" IsUpdate?: "+isUpdate+" "+"\n");
            if(isUpdate)
            {
                stmt.executeUpdate(szQueryString);
            }
            else
            {
                rs =  stmt.executeQuery(szQueryString);
            }
            
            return rs;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }
    }

    public Manage()
    {
        try
        {
            // Get DriverManager class
            Class.forName("com.mysql.jdbc.Driver");
            // DriverManager Connection
            conn=DriverManager.getConnection(url,id,pw);
            // check server connect
            System.out.print("Server connect\n");

        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }

    public void Close()
    {
        try
        {
                conn.close();
                System.out.print("Server disconnect\n");
        }
        catch(Exception e)
        {
                e.printStackTrace();
        }
    }
	
    public void CheckExecute()
    {
        try
        {
                System.out.print("Check Java Code\n");
        }
        catch(Exception e)
        {
                e.printStackTrace();
        }
    }
}
