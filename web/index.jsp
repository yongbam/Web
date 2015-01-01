<%-- 
    Document    :   index
    Created on  :   2014. 12. 29,AM 09:27:09    Start
    Part        :   2014. 12. 29 AM 11:00:00    UI partly
                    2014. 12. 29 PM 6:01:00     Check values
                    2014. 12. 30 PM 4:04:00     Connect all values with database
                    2014. 12. 31 PM 2:04:00     Solve save query error
                    2014. 12. 31 PM 6:04:00     Solved most things except query when dblclick result

    Author      :   yong il Kim
--%>

<%@page import="ybk.util.Compare"%>
<%@page import="ybk.util.NNString"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import = "ybk.db.*" %>
<%@page import = "java.sql.*" %>
<%@ page import="java.util.Date"%>

<%
    // New start
    System.out.print("=================================================\n");
    
    // CONST DEFINE
    final int ACTION_NOTHING=0;
    final int ACTION_SEARCH_KEY=1;
    final int ACTION_QUERY=2;
    final int ACTION_SAVE=3;
    final int ACTION_DELETE=4;
    final int ACTION_CLOSE=5;
    
    // Initialze values
    
    // Custom save object
    Custom custom_val = new Custom();
    
    // Database
    final Manage db= new Manage();
    
    // Result by query database
    ResultSet rs = null;
    
    // Check session saved business number
    String num="";
    if(session.getAttribute("B_NUMBER")!=null)
    {
        num = session.getAttribute("B_NUMBER").toString();
        session.setAttribute("B_NUMBER", "");
    }
    
    // Get
    request.setCharacterEncoding("utf-8");
    
    //
    System.out.print("End session and request encoding\n");
    
    // What search? 
    CustomKey custom_key = new CustomKey();
    custom_key.set_busi_num(request.getParameter("b_number") );
    custom_key.set_custom(request.getParameter("c_name") );
    //
    System.out.print("Set custom_key from request\n");
    
    // Type of button
    final String submit_bt = request.getParameter("submit_bt");
    final String getcontent_bt = request.getParameter("getcontent_bt");
    final String save_bt = request.getParameter("save_bt");
    final String delete_bt = request.getParameter("delete_bt");
    final String close_bt = request.getParameter("close_bt");
    
    int button_type = ACTION_NOTHING;
    if(submit_bt!=null)
        button_type = ACTION_SEARCH_KEY;
    if(getcontent_bt!=null)
        button_type = ACTION_QUERY;
    if(save_bt!=null)
        button_type = ACTION_SAVE;
    if(delete_bt!=null)
        button_type = ACTION_DELETE;
    if(close_bt!=null)
        button_type = ACTION_CLOSE;
    
    //
    System.out.print("Set submit button request: ");
    switch(button_type)
    {
        case ACTION_NOTHING:
            System.out.print("nothing\n");break;
        case ACTION_SEARCH_KEY:
            System.out.print("submit\n");break;
        case ACTION_QUERY:
            System.out.print("getcontent\n");break;
        case ACTION_SAVE:
            System.out.print("save\n");break;
        case ACTION_DELETE:
            System.out.print("delete\n");break;
        case ACTION_CLOSE:
            System.out.print("close\n");break;
    }
   
    //
    System.out.print("Set submit_buttons from request\n");
    
    ArrayList<String> updateCustomAcoontList = null;
    ArrayList<String> insertCustomAccountList= null;
    
    // for delete
    if(ACTION_DELETE==button_type)
    {
        custom_val.Key.BUSI_NUM.set(request.getParameter("bc_number") );
    }
    // only for save
    if(ACTION_SAVE==button_type)
    {
        // Get custom - Key
        custom_val.Key.BUSI_NUM.set(request.getParameter("bc_number") );
        custom_val.Key.CUSTOM.set(request.getParameter("bc_name") );

        // Get custom - Content
        custom_val.Content.SHORT.set(request.getParameter("bcs_name") );
        custom_val.Content.CEO.set(request.getParameter("ceo_name") );
        custom_val.Content.CHARGE_PERSON.set(request.getParameter("supervisor_name") );
        custom_val.Content.BUSI_CONDITION.set(request.getParameter("bc_type") );
        custom_val.Content.ITEM.set(request.getParameter("bc_item") );
        custom_val.Content.POST_NUM.set(request.getParameter("post_number") );
        custom_val.Content.ADDR1.set(request.getParameter("address"));
        custom_val.Content.ADDR2.set(request.getParameter("address_left") );
        custom_val.Content.TEL.set(request.getParameter("tel_num"));
        custom_val.Content.FAX.set(request.getParameter("fax_num"));
        custom_val.Content.HOMEPAGE.set(request.getParameter("homepage") );
        // private/company
        custom_val.Content.BUSI_CONDITION.set(request.getParameter("business_type"));
        // in/out
        NNString l_type=new NNString(request.getParameter("location_type") );
        custom_val.Content.FOREIGN_YN=false;
        if(l_type.get().equals("in") )
            custom_val.Content.FOREIGN_YN=true;
        custom_val.Content.COUNTRY_ENG.set(request.getParameter("country_code"));
        custom_val.Content.COUNTRY_KOR.set(request.getParameter("country_name") );
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        // why now showed?
        custom_val.Content.CONTRACT_PERIOD_S = 
                request.getParameter("contract_start")==""?null:sdf.parse(request.getParameter("contract_start") );
        custom_val.Content.CONTRACT_PERIOD_E =
                request.getParameter("contract_end")==""?null:sdf.parse(request.getParameter("contract_end") );
        custom_val.Content.REGI_INFO_MAN.set(request.getParameter("registered_name") );
        custom_val.Content.MODI_INFO_MAN.set(request.getParameter("modified_name") );
        custom_val.Content.TAX_YN = request.getParameter("tax_yn")==null?false:true;
        custom_val.Content.SPECIAL_RELATION= request.getParameter("special_relation")==null?false:true;
        custom_val.Content.TRADE_STOP = request.getParameter("trade_stop")==null?false:true;
        //
        System.out.print("Set custom from request\n");
    
        // Get Account
        final String[] office_name = request.getParameterValues("office_name");
        final String[] bank_name = request.getParameterValues("bank_name");
        final String[] account_num = request.getParameterValues("account_num");

        if(office_name!=null && bank_name!=null && account_num!=null)
        {
            Compare cmp = new Compare();
            int length = cmp.getMostBigNumber(office_name.length, bank_name.length, account_num.length );
            for( int i=0; i<length; ++i)
            {
                custom_val.SetAccount(office_name[i], bank_name[i], account_num[i]);
            }
        }
        
        //
        System.out.print("Set account from request\n");

        // Query -insert account, if not modified, accountList can have many account
        if(office_name!=null&& bank_name!=null && account_num!=null)
        {
            insertCustomAccountList=new ArrayList();
            for(int i=0; i<office_name.length; ++i)
            {
                if(office_name[i].length()>0)
                    insertCustomAccountList.add(
                            "INSERT INTO account VALUES("+custom_val.Key.BUSI_NUM.get(1)+","
                                    +"'"+office_name[i]+"','"+bank_name[i]+"','"+account_num[i]+"');"
                    );
            }
        }

        // Query - update account, if modified, accountList can have many account
        if(office_name!=null&& bank_name!=null && account_num!=null)
        {
            updateCustomAcoontList=new ArrayList();
            for(int i=0; i<office_name.length; ++i)
            {
                if(office_name[i].length()>0)
                    updateCustomAcoontList.add(
                            "UPDATE account SET FACTORY='"
                                    +office_name[i]+"', TRADE_BANK='"+bank_name[i]+"', ACCOUNT_NUM='"+account_num[i]
                                    +"' WHERE BUSI_NUM="+custom_val.Key.BUSI_NUM.get(1)+";"
                    );
            }
        }
        
        //
        System.out.print("Make queries for account\n");
    }
    
    //
    System.out.print("Session 'B_NUMBER' is "+num+"\n");
    System.out.print("bcnumber="+custom_val.Key.BUSI_NUM.get()+"\n");
    
    //
    System.out.print("End get request\n");
    
    // Query of view all customs
    final String viewCustomList = "SELECT BUSI_NUM, CUSTOM FROM custom ORDER BY custom;";
    
    // Query of wanted custom
    final String viewCustomWantedList = "SELECT BUSI_NUM, CUSTOM FROM custom WHERE BUSI_NUM='"
            +custom_key.get_busi_num()
            +"' OR CUSTOM='"+custom_key.get_custom()+"' ORDER BY custom;";
    
    // Query - account list of custom
    final String viewACustomAccount="SELET FACTORY, TRADE_BANK, ACCOUNT_NUM FROM account WHERE BUSI_NUM='"+num+"';";
    
    // Query of wanted custom
    final String viewCustomContents = "SELECT * FROM custom WHERE BUSI_NUM='"+num+"';";
    
    // Query of wanted custom's account list
    final String viewCustomAccountContents = "SELECT * FROM account WHERE BUSI_NUM='"+num+"';";
    
    // Query of delete custom
    final String deleteCustom = "DELETE FROM custom WHERE BUSI_NUM="+custom_val.Key.BUSI_NUM.get(1)+";";
    
    //
    System.out.print("Set queries\n");
    //
    System.out.print("End initialized\n");
    
    //
    System.out.print("Now Action is ");
    if(button_type>ACTION_SEARCH_KEY)
    try
    {
        switch(button_type)
        {
            case ACTION_QUERY:
                // Show custom contents
                System.out.print("QUERY\n");
                if(num.length()>0)
                {
                    // custom is just one
                    rs = db.ExecuteQuery(viewCustomContents);
                    if(rs.next() )
                    {
                        custom_val.SetCustom(rs);
                    }
                    // account can have many count
                    rs = db.ExecuteQuery(viewCustomAccountContents);
                    while(rs.next() )
                    {
                        custom_val.SetAccount(rs);
                    }
                }
                session.setAttribute("B_NUMBER", custom_val.Key.BUSI_NUM.get() );
                
                break;
            case ACTION_SAVE:
                // Save custom
                System.out.print("SAVE\n");
                
                // If same and previous busi_num saved then update, else insert
                System.out.println("!!!!!!!");
                System.out.println(num.length());//13
                System.out.println(num.equals(custom_val.Key.BUSI_NUM.get()));//true
                System.out.println(custom_val.Key.BUSI_NUM.isEmpty());//false
                System.out.println("!!!!!!!");
                if(num.length()>0 && 
                        num.equals(custom_val.Key.BUSI_NUM.get()) && 
                        !custom_val.Key.BUSI_NUM.isEmpty())
                {
                    System.out.print("Save custom - update query\n");
                    // Custom
                    rs = db.ExecuteQuery(custom_val.updateSaveCustom(num) );

                    // Account
                    for(String updateAccountQuery : updateCustomAcoontList)
                        rs = db.ExecuteQuery(updateAccountQuery);
                }
                else
                {
                    System.out.print("Save custom - insert query\n");
                    
                    // Custom
                    rs = db.ExecuteQuery(custom_val.insertSaveCustom() );

                    // Account
                    for(String insertAccountQuery : insertCustomAccountList)
                        rs = db.ExecuteQuery(insertAccountQuery);
                }
                session.setAttribute("B_NUMBER", custom_val.Key.BUSI_NUM.get() );
                
                break;
            case ACTION_DELETE:
                // Delete custom
                System.out.print("DELETE\n");
                rs = db.ExecuteQuery(deleteCustom);
                // BUSI_NUM initialize
                custom_val.Key.BUSI_NUM.set("");
                session.setAttribute("B_NUMBER", "");
                break;
            case ACTION_CLOSE:
                // Nothing, not specification
                System.out.print("CLOSE\n");
                break;
        }
        
        //
        System.out.print("End button request 2~5\n");
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    
    // No need to query cuz now act about content
    try 
    {    
        // Array of custom
        final ArrayList<CustomKey> customKeyList = new ArrayList();

        // First get all custom p.k and s.k and check in java, cuz when search its speed is faster than query
        
        // Query database
        Boolean wanted = false;
        
        //
        System.out.printf(custom_key.get_busi_num() + " "+custom_key.get_custom()+"\n");
        
        if(custom_key.get_busi_num().isEmpty() && custom_key.get_custom().isEmpty())
        {
            rs = db.ExecuteQuery(viewCustomList);
        }
        else
        {
            rs = db.ExecuteQuery(viewCustomWantedList);
            wanted = true;
        }
        
        //
        System.out.print("End query custom\n");
        
        if(rs==null)
        {
            System.out.print("rs is null\n");
        }
        
        // If result exist
        while(rs.next() )
        {
            CustomKey resultKey = new CustomKey();
            // Get values from database
            resultKey.set_busi_num(rs.getString("BUSI_NUM"));
            resultKey.set_custom(rs.getString("CUSTOM"));

            // Add to arrayList
            customKeyList.add(resultKey);
            
            if(wanted)
            {
                session.setAttribute("B_NUMBER", resultKey.get_busi_num());
            }
        }
%>

<!DOCTYPE html>
<html>
    <!-- head -->
    <head>
        <!-- Default -->
        <title>Portfolo</title>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        
        <!-- JQuery -->
        <script type="text/javascript" src="js/jquery-1.3.2.min.js" ></script>
        
        <!-- Get javascript what used here -->
        <script type="text/javascript" src="js/manage.js" ></script>
        
        <!-- Get css what used here -->
        <link rel="stylesheet" type="test/css" href="css/manage.css" />
        
    </head>
    
    <!-- body -->
    <body>
        <%
                    switch(button_type)
                    {
                case ACTION_SAVE:
                    %>
                    <script>alert("SAVE");</script>
                    <%
                    break;
case ACTION_DELETE:
    %>
    <script>alert("DELETE");</script>
    <%
    break;
                }
%>

        <!-- Header - title and buttons -->
        <div id="header">
            <table>
                <tr>
                    <td>
                        <h1>[실기 TEST] 거래처 관리</h1>
                    </td>
                </tr>
            </table>
        </div>
        <!-- Search - input business number and name -->
        <div id="search" style="
             position: fixed;
             left: 10px;
             top: 70px;
             width: 290px;
             ">
            <form name="search_form" id="search_form" action="index.jsp" method="POST">
            <fieldset>
                <legend>Search content</legend>
                <table>
                    <tr>
                        <td>사업자 번호</td>
                        <td colspan="2">
                            <input class="field" type="text" name="b_number" placeholder="business number"
                                   pattern="\d{4}-\d{3}-\d{4}"
                                   oninvalid="setCustomValidity('Enter invalidate number like 1111-111-1111')"
                                   onchange="try{setCustomValidity('');}catch(e){}"
                                   id="b_number" value="" maxlength='20' />
                        </td>
                    </tr>
                    <tr>
                        <td>거래처명</td>
                        <td>
                            <input class="field" type="text" name="c_name" placeholder="company name"
                                   pattern='^[가-힣a-zA-Z ]+$'
                                   oninvalid="setCustomValidity('Only allow 한국어 or English alphbet')"
                                   onchange="try{setCustomValidity('');}catch(e){}"
                                   id="signup" value="" size="14" maxlength="10" />
                        </td>
                        <td>
                            <input class=field" type="submit" name="submit_bt" value="조회"/> 
                        </td>
                    </tr>
                </table>
            </fieldset>
            </form>
        </div>
        <!-- Result of search -->
        
        <div id="result_div" style="
             position: fixed;
             left: 10px;
             top: 160px;
             width: 290px;
             ">
            <form name="resultquery_form" id="resultquery_form" action="index.jsp" method="GET">
            <fieldset>
                <legend>Result</legend>
                <table id="result_table" border="1px" >
                    <tr>
                        <td>사업자 번호</td>
                        <td>거래처명</td>
                    </tr>
<%
        for(CustomKey cus_val : customKeyList )
        {
%>
                    <tr>
                        <td>
                            <!-- No meaning about limit maxlength -->
                            <input class="field" type="text" name="searchResutKey" 
                                   value="<%=cus_val.get_busi_num()%>"
                                   readonly
                                   onclick='submitBusinessNumber(this);' />
                            <input type="hidden" name="bc_number" />
                            <input type="hidden" name="getcontent_bt" value="HELLO"/>
                                
                        </td>
                        <td>
                            <!-- No meaning about limit maxlength -->
                            <input class="field" type="text" name="searchResultCustom" 
                                   value="<%=cus_val.get_custom()%>"
                                   readonly
                                   onclick='submitCustomName(this);' />
                            <input type="hidden" name="bc_name" />
                            <input type="hidden" name="getcontent_bt" value='HELLO' />
                        </td>
                    </tr>
<%
        
        }
%>
                </table>
            </fieldset>
            </form>
        </div>
        <!-- Contents of business client -->
        <form name="getcontent_form" id="getcontent_form" action="index.jsp" method="POST">
        <div id="content" style="
             position: fixed;
             left: 300px;
             top: 70px;
             width: 930px;
             ">
            <fieldset>
                <legend>Content</legend>
                <table id="button_table">
                    <!-- Buttons -->
                        <tr>
                            <td colspan="4" width="600px">
                            </td>
                            <td>
                                <input class=field" type="submit" name="getcontent_bt" value="조회" />
                            </td>
                            <td>
                                <input class=field" type="submit" name="save_bt" value="저장" onclick="layer_open('layer2');"/>
                            </td>
                            <td>
                                <input class=field" type="submit" name="delete_bt" value="삭제" onclick="layer_open('layer2');"/>
                            </td>
                            <td>
                                <button onclick="
                                    layer_open('layer2');open(location, '_self').close();">닫기</button>
                            </td>
                        </tr>
                </table>
                <table id="content_table" border="1px">
                    <!-- Business title -->
                    <tr>
                        <td>사업자 번호</td>
                        <td colspan="3">
                            <input class="field" type="text" name="bc_number" placeholder="business client number"
                                   pattern="\d{4}-\d{3}-\d{4}"
                                   oninvalid="setCustomValidity('Enter invalidate number like 1111-111-1111')"
                                   onchange="try{setCustomValidity('');}catch(e){}"
                                   id="bc_number" value="<%=custom_val.Key.BUSI_NUM.get()%>" maxlength="20" />
                        </td>
                        <td>약칭</td>
                        <td colspan="3">
                            <input class="field" type="text" name="bcs_name" placeholder="business client short name"
                                   pattern='^[가-힣a-zA-Z ]+$'
                                   oninvalid="setCustomValidity('Only allow 한국어 or English alphbet')"
                                   onchange="try{setCustomValidity('');}catch(e){}"
                                   id="bcs_name" value="<%=custom_val.Content.SHORT.get()%>" maxlength="10" />
                        </td>
                    </tr>
                    <!-- Custom name -->
                    <tr>
                        <td>거래처명</td>
                        <td colspan="7">
                            <input class="field" type="text" name="bc_name" placeholder="business client name"
                                   pattern='^[가-힣a-zA-Z ]+$'
                                   oninvalid="setCustomValidity('Only allow 한국어 or English alphbet')"
                                   onchange="try{setCustomValidity('');}catch(e){}"
                               id="bc_name" value="<%=custom_val.Key.CUSTOM.get()%>" maxlength='20' />
                        </td>
                    </tr>
                    <!-- Vusiness CEO -->
                    <tr>
                        <td>대표자</td>
                        <td colspan="3">
                            <input class="field" type="text" name="ceo_name" placeholder="CEO name" 
                                   name="ceo_name" id="ceo_name" maxlength="10"
                                   value="<%=custom_val.Content.CEO.get()%>" />
                        </td>
                        <td>담당자</td>
                        <td colspan="3">
                            <input class="field" type="text" name="supervisor_name" placeholder="supervisor name"
                                   id="supervisor_name" name="supervisor_name" maxlength="10"
                                   value="<%=custom_val.Content.CHARGE_PERSON.get()%>" />
                        </td>
                    </tr>
                    <!-- 
                    Business Type 
                    Content from http://www.namevalue.org/?p=2702
                    -->
                    <tr id="business_condition">
                        <td>업태</td>
                        <td colspan="2">
                            <!-- No meaning about limited maxlength cuz get from another popup window -->
                            <input class="field" type="text" name="bc_type" placeholder="click button" readonly
                                   readonly id="bc_type" tabindex="-1"
                                   value="<%=custom_val.Content.BUSI_CONDITION.get()%>" />
                        </td>
                        <td>
                            <!-- Later test about hidden item -->
                            <a href='#' ONCLICK="window.open(
                                        'business_type_search.jsp','win','width=450,height=350,\n\menubar=no,scrollbars=yes');return false">
                                <button type="button">검색</button>
                            </a>
                        </td>
                        <td>종목</td>
                        <td colspan="3">
                            <!-- No meaning about limited maxlength cuz get from another popup window -->
                            <input class="field" type="text" name="bc_item" placeholder="click button" readonly
                                   readonly id="bc_item" tabindex="-1"
                                   value="<%=custom_val.Content.ITEM.get()%>" />
                        </td>
                    </tr>
                    <!-- Hide area for search business condtion items -->
                    <tr id="search_business_condition" style="
                        display: none;">
                        <td colspan="8">
                            <table>
                                <tr 
                                    onmouseover="ChangeColor(this, true);" 
                                    onmouseout="ChangeColor(this, false);"
                                    onclick="SetBusinessCondition('금융 및 보험업', '생명보험')">
                                    <td>금융 및 보험업</td><td>생명보험</td>
                                </tr>
                                <tr 
                                    onmouseover="ChangeColor(this, true);" 
                                    onmouseout="ChangeColor(this, false);"
                                    onclick="SetBusinessCondition('금융 및 보험업', '재보험')">
                                    <td>금융 및 보험업</td><td>재보험</td>
                                </tr>
                                <tr 
                                    onmouseover="ChangeColor(this, true);" 
                                    onmouseout="ChangeColor(this, false);"
                                    onclick="SetBusinessCondition('금융 및 보험업', '화재보험')">
                                    <td>금융 및 보험업</td><td>화재보험</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <!-- Address -->
                    <tr>
                        <td>우편번호</td>
                        <td colspan="2">
                            <!-- No meaning about limited maxlength cuz get from another popup window -->
                            <input class="field" type="text" name="post_number" placeholder="Click search button" 
                                   readonly id="post_number" tabindex="-1"
                                   value="<%=custom_val.Content.POST_NUM.get()%>" />
                        </td>
                        <td>
                            <a href='#' ONCLICK="window.open(
                                        'zipcode_search.jsp','win','width=450,height=350,\n\menubar=no,scrollbars=yes');return false">
                                <button type="button">검색</button>
                            </a>
                        </td>
                        <td>주소1</td>
                        <td colspan="3">
                            <!-- No meaning about limited maxlength cuz get from another popup window -->
                            <input class="field" type="text" name="address" placeholder="Click search button"
                                   readonly id="address" tabindex="-1"
                                   value="<%=custom_val.Content.ADDR1.get()%>" />
                        </td>
                    </tr>
                    <!-- Last address -->
                    <tr>
                        <td>주소2</td>
                        <td colspan="7">
                            <input class="field" type="text" name="address_left" placeholder="Input last address"
                               id="address_left" maxlength="80"
                               pattern="^[가-힣a-zA-Z0-9 ]+$"
                               oninvalid="setCustomValidity('Only allow 한국어 or number or English alphbet')"
                               onchange="try{setCustomValidity('');}catch(e){}"
                               value="<%=custom_val.Content.ADDR2.get()%>" />
                        </td>
                    </tr>
                    <!-- Call number -->
                    <tr>
                        <td>전화번호</td>
                        <td colspan="3">
                            <input class="field" type="text" name="tel_num" placeholder="call number"
                                   patern="^[0]\d{1,2}-\d{3,4}-\d{4}"
                                   oninvalid="setCustomValidity('Only allow like 02(010)-1234(123)-5678')"
                                   onchange="try{setCustomValidity('');}catch(e){}"
                                   id="tel_num" maxlength="13"
                                   value="<%=custom_val.Content.TEL.get()%>" />
                        </td>
                        <td>팩스번호</td>
                        <td colspan="3">
                            <input class="field" type="text" name="fax_num" placeholder="fax number"
                                   pattern="^[0]\d{1,2}-\d{3,4}-\d{4}"
                                   oninvalid="setCustomValidity('Only allow like 02-1234-5678')"
                                   onchange="try{setCustomValidity('');}catch(e){}"
                                   id="fax_num" maxlength="13"
                                   value="<%=custom_val.Content.FAX.get()%>" />
                        </td>
                    </tr>
                    <!-- Homepage -->
                    <tr>
                        <td>홈페이지</td>
                        <td colspan="7">
                            <input class="field" type="text" name="homepage" placeholder="client homepage"
                                   pattern="^((http(s?))://)([0-9a-zA-Z]+.)+[a-zA-Z]{2,6}(:[0-9]+)?(S*)"
                                   oninvalid="setCustomValidity('Only allow like http(s)://www.Korea.org')"
                                   onchange="try{setCustomValidity('');}catch(e){}"
                                   id="homepage" maxlength="20"
                                   value="<%=custom_val.Content.HOMEPAGE.get()%>" />
                        </td>
                    </tr>
                    <!-- Combo box -->
                    <tr>
                        <td>법인여부</td>
                        <td colspan="1">
                            <input type="radio" name="business_type" value="company" 
                                   <%
                                   if(custom_val.Content.CO_YN)
                                   {
                                   %>
                                   checked />법인
                                   <%
                                   }
                                   else
                                   {
                                       %>
                                       />법인
                                       <%
                                   }
                                   %>                                   
                            <input type="radio" name="business_type" value="private"
                                   <%
                                   if(!custom_val.Content.CO_YN)
                                   {
                                   %>
                                   checked />개인
                                   <%
                                   }
                                   else
                                   {
                                       %>
                                       />국외
                                       <%
                                   }
                                   %>
                        </td>
                        <td colspan="2"></td>
                        <td>해외여부</td>
                        <td colspan="3">
                            <input type="radio" name="location_type" value="in"
                                   <%
                                   if(custom_val.Content.FOREIGN_YN)
                                   {
                                   %>
                                   checked />국내
                                   <%
                                   }
                                   else
                                   {
                                       %>
                                       />국내
                                       <%
                                   }
                                   %>
                            <input type="radio" name="location_type" value="out"
                                   <%
                                   if(!custom_val.Content.FOREIGN_YN)
                                   {
                                   %>
                                   checked />국외
                                   <%
                                   }
                                   else
                                   {
                                       %>
                                       />국외
                                       <%
                                   }
                                   %>
                        </td>
                    </tr>
                    <!-- Country -->
                    <tr>
                        <td>과세구분</td>
                        <td colspan="3">
                            <select name="tax_yn">
                                <option 
                                    <%
                                   if(custom_val.Content.TAX_YN)
                                   {
                                   %>
                                   selected="selected" >과세</option>
                                   <%
                                   }
                                   else
                                   {
                                       %>
                                       >과세</option>
                                       <%
                                   }
                                   %>
                                <option
                                    <%
                                   if(!custom_val.Content.TAX_YN)
                                   {
                                   %>
                                   selected="selected" >면세</option>
                                   <%
                                   }
                                   else
                                   {
                                       %>
                                       >면세</option>
                                       <%
                                   }
                                   %>
                            </select>
                        </td>
                        <td>국가</td>
                        <td>
                            <!-- No meaning about limited maxlength cuz get from another popup window -->
                            <input class="field" type="text" name="country_code" placeholder=""
                                   readonly id="country_code" tabindex="-1"
                                   value="<%=custom_val.Content.COUNTRY_ENG.get()%>" />
                        </td>
                        <td>
                            <!-- No meaning about limited maxlength cuz get from another popup window -->
                            <input class="field" type="text" name="country_name" placeholder="Click Button"
                                   readonly id="country_name" tabindex="-1"
                                   value="<%=custom_val.Content.COUNTRY_KOR.get()%>" />
                        </td>
                        <td>
                            <a href='#' ONCLICK="window.open(
                                        'country_search.jsp','win','width=450,height=350,\n\menubar=no,scrollbars=yes');return false">
                                <button type="button">검색</button>
                            </a>
                        </td>
                    </tr>
                    <!-- Check box -->
                    <tr>
                        <td>특수관계자</td>
                        <td colspan="3">
                            <input type="checkbox" name="special_relation" value="special_relation" 
                                   <%
                                   if(custom_val.Content.SPECIAL_RELATION)
                                   {
                                   %>
                                   checked />
                                   <%
                                   }
                                   else
                                   {
                                       %>
                                       />
                                       <%
                                   }
                                   %>
                        </td>
                        <td>거래중지</td>
                        <td colspan="3">
                            <input type="checkbox" name="trade_stop" value="trade_stop"
                                   <%
                                   if(custom_val.Content.TRADE_STOP)
                                   {
                                   %>
                                   checked />
                                   <%
                                   }
                                   else
                                   {
                                       %>
                                       />
                                       <%
                                   }
                                   %>
                        </td>
                    </tr>
                    <!-- Connected date -->
                    <tr>
                        <td>계약기간</td>
                        <td colspan="1">
                            <input class="field" type="date" name="contract_start"  
                               id="contract_start" value="<%=custom_val.Content.CONTRACT_PERIOD_S%>" size="23" />
                        </td>
                        <td>~</td>
                        <td colspan="1">
                            <input class="field" type="date" name="contract_end"  
                               id="contract_end" value="<%=custom_val.Content.CONTRACT_PERIOD_E%>" size="23" />
                        </td>
                    </tr>
                    <!-- Submited date -->
                    <tr>
                        <td>등록정보</td>
                        <td>
                            <input class="field" type="text" name="registered_name" placeholder="Write name who registerd"  
                               id="registered_name" maxlength="10"
                               pattern="^[가-힣a-zA-Z0-9 ]+$"
                               oninvalid="setCustomValidity('Only allow 한국어 or number or English alphbet')"
                               onchange="try{setCustomValidity('');}catch(e){}"
                               value="<%=custom_val.Content.REGI_INFO_MAN.get()%>" />
                        </td>
                        <td colspan="2">
                            <input class="field" type="datetime-local" name="registered_date" 
                                   readonly id="registered_date" tabindex="-1"
                                   value="<%=custom_val.Content.REGI_INFO_DATE%>" />
                        </td>
                        <td>변경정보</td>
                        <td>
                            <input class="field" type="text" name="modified_name" placeholder="Write name who modified"  
                                   id="modified_name" maxlength="10"
                                   pattern="^[가-힣a-zA-Z0-9 ]+$"
                                   oninvalid="setCustomValidity('Only allow 한국어 or number or English alphbet')"
                                   onchange="try{setCustomValidity('');}catch(e){}"
                                   value="<%=custom_val.Content.MODI_INFO_MAN.get()%>" />
                        </td>
                        <td colspan="2">`
                            <input class="field" type="datetime-local" name="modified_date"
                                   readonly tabindex="-1" id="modified_date" 
                                   value="<%=custom_val.Content.MODI_INFO_DATE%>" />
                        </td>
                    </tr>
                    <!-- Account title -->
                    <tr>
                        <td colspan="8">
                            (거래처 계좌정보)
                        </td>
                    </tr>
                    <!-- Account contents -->
                    <tr>
                        <td colspan="8">
                            <table id="account_table" border="1px">
                                <tr>
                                    <td>사무소</td>
                                    <td>은행</td>
                                    <td>계좌번호</td>
                                </tr>
                                <%
                                for(Custom.Account_ acc : custom_val.AccountList)
                                {
                                %>
                                <tr>
                                    <td>
                                        <input class="field" type="text" name="office_name" placeholder="Office Name"  
                                               id="office_name" maxlength="20"
                                               pattern="^[가-힣a-zA-Z0-9 ]+$"
                                               oninvalid="setCustomValidity('Only allow 한국어 or number or English alphbet')"
                                               onchange="try{setCustomValidity('');}catch(e){}"
                                               value="<%=acc.FACTORY.get()%>" />
                                    </td>
                                    <td>
                                        <input class="field" type="text" name="bank_name" placeholder="Bank name"
                                               pattern="^[가-힣a-zA-Z0-9 ]+$"
                                               oninvalid="setCustomValidity('Only allow 한국어 or number or English alphbet')"
                                               onchange="try{setCustomValidity('');}catch(e){}"
                                               id="bank_name" maxlength="20"
                                               value="<%=acc.TRADE_BANK.get()%>" />
                                    </td>
                                    <td>
                                        <input class="field" type="text" name="account_num" placeholder="Account number"
                                               pattern="^[가-힣a-zA-Z0-9 ]+$"
                                               oninvalid="setCustomValidity('Only allow 한국어 or number or English alphbet')"
                                               onchange="try{setCustomValidity('');}catch(e){}"
                                               id="account_num" maxlength="20" 
                                               value="<%=acc.ACCOUNT_NUM.get()%>" />
                                    </td>
                                </tr>
                                <%
                                }
                                %>
                            </table>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
        </form>
                            
        <!-- Fixed layout popup -->
        <!--
        <div class="layer">
            <div class="bg"></div>
            <div id="layer2" class="pop-layer">
                <div class="pop-container">
                    <div class="pop-conts">
                        <p class="ctxt mb20">Thank you.<br>
                        </p>

                        <div class="btn-r">
                            <a href="#" class="cbtn">Close</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        -->
    </body>
</html>
<%
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
%>