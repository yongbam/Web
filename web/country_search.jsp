<%-- 
    Document   : country_search
    Created on : 2014. 12. 30, 오전 10:38:38
    Author     : yongbam
--%>

<%@page import="data.custom.Country"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Country</title> 
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
                    alert("찾으려는 국가 명을 입력하시오."); 
                    document.Zip.address.focus(); 
                    return false; 
                } 
                else{ 
                    document.Zip.action="country_search.jsp"; 
                    document.Zip.submit(); 
                    return true;
                } 
            } 

            function confirm(dck) 
            { 
                if (dck.zip_chk.length == null) { 
                    var n =dck.zip_chk.value.indexOf("_");
                    var country_eng = dck.zip_chk.value.substring(0,n); 
                    var country_kor = dck.zip_chk.value.substring(n+1); 
                }
                for(var i=0; i<dck.zip_chk.length; i++) { 
                    if(dck.zip_chk[i].checked == true) { 
                        var n =dck.zip_chk.value.indexOf("_");
                        var country_eng = dck.zip_chk.value.substring(0,n); 
                        var country_kor = dck.zip_chk.value.substring(n+1); 
                        break; 
                    } 
                } 
                if( i==dck.zip_chk.length ) { 
                    alert("해당 국가 명을 선택하세요."); 
                } 
                else {
                    window.opener.document.getcontent_form.country_code.value=country_eng;
                    window.opener.document.getcontent_form.country_name.value=country_kor;
                    open(location, '_self').close();
                    
                } 
            } 
        </script> 
    </head>
    <body  onload="document.Zip.address.focus()">
        <center>
        <font color=Green size=3>국가 코드 검색</font> 
        <hr size=0 width=95%> 
        <font>해당 국가 명을 입력하세요.<br> 예) '대한민국' , '일본' , '미국'</font> 
        <p> 
        <form method="POST" name="Zip" onSubmit="return Zip_search();"> 
            <hr size=0 width=95%> 
            <input type="text" name="address" size="20" maxlength="20" value="" style='border:solid 1;'> 
            <button onclick="Zip_search()">국가 검색</button>
            <hr size=0 width=95%> 
        </form> 
        <table border=0 width=90%><tr><td> 
        <%
            request.setCharacterEncoding("utf-8");
            final String address = request.getParameter("address");
            
            //
            System.out.print("address = " + address+"\n");
            
            ArrayList<Country> addressList = new ArrayList();
            
            // Temporary input, normally get from database
            // From https://digitalid.crosscert.com/secureserver/server/help/ccodes.htm
            Country val1= new Country();
            Country val2= new Country();
            Country val3= new Country();
            Country val4= new Country();
            Country val5= new Country();
            
            val1.ShortEngName="KOR";
            val1.KoreanName="대한민국";
            addressList.add(val1);
            
            val2.ShortEngName="US";
            val2.KoreanName="미국";
            addressList.add(val2);
            
            val3.ShortEngName="AZ";
            val3.KoreanName="아제르바이잔";
            addressList.add(val3);
            
            val4.ShortEngName="JP";
            val4.KoreanName="일본";
            addressList.add(val4);
            
            Boolean isExist = false;
            if(address!=null)
            for(Country addr_val : addressList)
            {
                //
                System.out.print(addr_val.ShortEngName+" "+addr_val.KoreanName+"\n" );
                if(addr_val.KoreanName.contains(address) )
                {
                    isExist = true;
                    break;
                }
            }
            if(address!=null)
            if(!isExist)
            {
                %>
                해당 국가를 찾지 못하였습니다.
                <%
            }
            else
            {
                for(Country addr_val : addressList)
                {
                    if(addr_val.KoreanName.contains(address) )
                    {
                %>
                    <form method='POST' name='check'>
                <%
                        String addr = addr_val.KoreanName;
                        String post_num = addr_val.ShortEngName;
                    %>
                        <input type='radio' name='zip_chk' value='<%=post_num %>_<%=addr%>'>
                        <font color=red><%=post_num %></font> <%=addr%><br>
                    <%
                    }
                }
                %>
                        <hr size=0>
                        <center>
                            <button onclick="confirm(document.check);">국가 명 및 국가 코드 입력</button>
                        </center>
                    </form>
                <%
            }
        %> 
        </td></tr></table></center> 
    </body>
</html>