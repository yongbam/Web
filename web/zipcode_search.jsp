<%-- 
    Document   : zipcode_search
    Created on : 2014. 12. 29, 오후 2:34:25
    Author     : yongbam
--%>

<%@page import="com.eaio.stringsearch.StringSearch"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ybk.db.Address"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Address</title> 
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
                    document.Zip.action="zipcode_search.jsp"; 
                    document.Zip.submit(); 
                    return true;
                } 
            } 

            function confirm(dck) 
            { 
                if (dck.zip_chk.length == null) { 
                    var zip_1 = dck.zip_chk.value.substring(0,3); 
                    var zip_2 = dck.zip_chk.value.substring(4,7); 
                    var zip_address = dck.zip_chk.value.substring(7); 
                } 
                for(var i=0; i<dck.zip_chk.length; i++) { 
                    if(dck.zip_chk[i].checked == true) { 
                        var zip_1 = dck.zip_chk[i].value.substring(0,3); 
                        var zip_2 = dck.zip_chk[i].value.substring(4,7); 
                        var zip_address = dck.zip_chk[i].value.substring(7); 
                        break; 
                    } 
                } 
                if( i==dck.zip_chk.length ) { 
                    alert("해당 주소를 선택하십시요."); 
                } 
                else {
                    window.opener.document.getcontent_form.post_number.value=zip_1+"-"+zip_2;
                    window.opener.document.getcontent_form.address.value=zip_address;
                    open(location, '_self').close();
                    
                } 
            } 
        </script> 
    </head>
    <body  onload="document.Zip.address.focus()">
        <center>
        <font color=Green size=3>우편번호검색 - Step 2/2</font> 
        <hr size=0 width=95%> 
        <font>찾으시는 동/읍/면/리 이름을 입력하세요.<br> 예) '행신동' , '목동' , '상계동'</font> 
        <p> 
        <form method="POST" name="Zip" onSubmit="return Zip_search();"> 
            <hr size=0 width=95%> 
            <input type="text" name="address" size="20" maxlength="20" value="" style='border:solid 1;'>
            <button OnClick="Zip_search();">Enter</button> 
            <hr size=0 width=95%> 
        </form> 
        <table border=0 width=90%><tr><td> 
        <%
            request.setCharacterEncoding("utf-8");
            final String address = request.getParameter("address");
            
            //
            System.out.print("address = " + address+"\n");
            
            ArrayList<Address> addressList = new ArrayList();
            
            // Temporary input, normally get from database
            // From http://www.epost.go.kr/search/zipcode/search1.jsp
            Address val1= new Address();
            Address val2= new Address();
            Address val3= new Address();
            Address val4= new Address();
            Address val5= new Address();
            
            val1.SetLocation("서울특별시 강남구 도곡1동 경남아파트 (101~104동)");
            val1.SetPostNumber("135-504");
            addressList.add(val1);
            
            val2.SetLocation("서울특별시 강남구 도곡1동 삼익아파트");
            val2.SetPostNumber("135-857");
            addressList.add(val2);
            
            val3.SetLocation("서울특별시 강남구 도곡1동 텔슨벤처타워");
            val3.SetPostNumber("135-739");
            addressList.add(val3);
            
            val4.SetLocation("서울특별시 강남구 도곡2동 우성4차아파트 (1~9동)");
            val4.SetPostNumber("135-505");
            addressList.add(val4);
            
            val5.SetLocation("서울특별시 구로구 구로3동 코오롱디지털타워빌란트");
            val5.SetPostNumber("152-777");
            addressList.add(val5);
            
            Boolean isExist = false;
            if(address !=null)
            for(Address addr_val : addressList)
            {
                // idk how to use..
                StringSearch ss;
                if(addr_val.GetLocation().contains(address) )
                {
                    isExist = true;
                    break;
                }
            }
            if(address !=null)
            if(!isExist)
            {
                %>
                Couldn't find address
                <%
            }
            else
            {
                for(Address addr_val : addressList)
                {
                    if(addr_val.GetLocation().contains(address) )
                    {
                %>
                    <form method='POST' name='check'>
                <%
                        String addr = addr_val.GetLocation();
                        String post_num = addr_val.GetPostNumber();
                    %>
                        <input type='radio' name='zip_chk' value='<%=post_num %><%=addr%>'>
                        <font color=red><%=post_num %></font><%=addr%><br>
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