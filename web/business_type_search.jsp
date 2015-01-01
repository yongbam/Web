<%-- 
    Document   : business_type_search
    Created on : 2014. 12. 30, 오전 10:54:14
    Author     : yongbam
--%>

<%@page import="ybk.db.Business_type"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Business_type</title> 
        <style type="text/css"> 
            BODY, table, tr, td, font,input, textarea, select 
            { 
                font-family: 굴림; 
                font-size: 9pt; 
            } 
        </style>
        <script Language="JavaScript"> 
            function Zip_search() { 
                if (document.Zip.address.value.length == 0) { 
                    alert("찾으시는 동이름을 입력하시오."); 
                    document.Zip.address.focus(); 
                    return false; 
                } 
                else{ 
                    document.Zip.action="business_type_search.jsp"; 
                    document.Zip.submit(); 
                    return true;
                } 
            } 

            function confirm(dck) 
            { 
                if (dck.zip_chk.length == null) { 
                    var n =dck.zip_chk.value.indexOf("_");
                    var type = dck.zip_chk.value.substring(0,n); 
                    var item = dck.zip_chk.value.substring(n+1); 
                } 
                for(var i=0; i<dck.zip_chk.length; i++) { 
                    if(dck.zip_chk[i].checked == true) { 
                        var n =dck.zip_chk.value.indexOf("_");
                        var type = dck.zip_chk.value.substring(0,n); 
                        var item = dck.zip_chk.value.substring(n+1); 
                        break; 
                    } 
                } 
                if( i==dck.zip_chk.length ) { 
                    alert("해당 주소를 선택하십시요."); 
                } 
                else {
                    window.opener.document.getcontent_form.bc_type.value=type;
                    window.opener.document.getcontent_form.bc_item.value=item;
                    open(location, '_self').close();
                    
                } 
            } 
        </script> 
    </head>
    <body  onload="document.Zip.address.focus()">
        <center>
        <font color=Green size=3>Search business type Name - Step</font> 
        <hr size=0 width=95%> 
        <font>Input business type.<br> 예) '금융 및 보험업' , 'IT' , '...'</font> 
        <p> 
        <form method="POST" name="Zip" onSubmit="return Zip_search();"> 
            <hr size=0 width=95%> 
            <input type="text" name="address" size="20" maxlength="20" value="" style='border:solid 1;'> 
            <button onclick="Zip_search()">OK</button>
            <hr size=0 width=95%> 
        </form> 
        <table border=0 width=90%><tr><td> 
        <%
            request.setCharacterEncoding("utf-8");
            final String address = request.getParameter("address");
            
            //
            System.out.print("address = " + address+"\n");
            
            ArrayList<Business_type> addressList = new ArrayList();
            
            // Temporary input, normally get from database
            // Content from http://www.namevalue.org/?p=2702
            Business_type val1= new Business_type();
            Business_type val2= new Business_type();
            Business_type val3= new Business_type();
            Business_type val4= new Business_type();
            
            val1.Type="금융 및 보험업";
            val1.Item="생명보험";
            addressList.add(val1);
            
            val2.Type="금융 및 보험업";
            val2.Item="재보험";
            addressList.add(val2);
            
            val3.Type="금융 및 보험업";
            val3.Item="화재보험";
            addressList.add(val3);
            
            val4.Type="IT";
            val4.Item="웹프로그램 개발";
            addressList.add(val4);
            
            Boolean isExist = false;
            if(address!=null)
            for(Business_type addr_val : addressList)
            {
                //
                System.out.print(addr_val.Type+" "+addr_val.Item+"\n" );
                if(addr_val.Type.contains(address) )
                {
                    isExist = true;
                    break;
                }
            }
            if(address!=null)
            if(!isExist)
            {
                %>
                Couldn't find country
                <%
            }
            else
            {
                for(Business_type addr_val : addressList)
                {
                    if(addr_val.Type.contains(address) )
                    {
                %>
                    <form method='POST' name='check'>
                <%
                    String addr = addr_val.Item;
                    String post_num = addr_val.Type;
                    %>
                        <input type='radio' name='zip_chk' value='<%=post_num %>_<%=addr%>'>
                        <font color=red><%=post_num %></font> <%=addr%><br>
                    <%
                    }
                }
                %>
                        <hr size=0>
                        <center>
                            <button onclick="confirm(document.check);">OK</button>
                        </center>
                    </form>
                <%
            }
        %> 
        </td></tr></table></center> 
    </body>
</html>