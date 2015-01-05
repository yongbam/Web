/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
// Check inputbox test maxlength
$(document).ready(function(){
    $('#input_text').keyup(function(){
        if ($(this).val().length > $(this).attr('maxlength')) {
            alert('제한길이 초과');
            $(this).val($(this).val().substr(0, $(this).attr('maxlength')));
        }
    });
});        

// If enter on account_num then add next row
function AddNewAccountInputRow()
{
    var table = document.getElementById("account_table");
    var row_count = $('#account_table tr').length;
    var row = table.insertRow(row_count);
    
    var cell1 = row.insertCell(0);
    var cell2 = row.insertCell(1);
    var cell3 = row.insertCell(2);

    cell1.innerHTML="<input class=\"field\" type=\"text\" name=\"office_name\" placeholder=\"Office Name\" id=\"office_name\" value=\"\" />";
    cell2.innerHTML="<input class=\"field\" type=\"text\" name=\"bank_name\" placeholder=\"Bank name\" id=\"bank_name\" value=\"\" />";
    cell3.innerHTML="<input class=\"field\" type=\"text\" name=\"account_num\" placeholder=\"Account number\" id=\"account_num\" value=\"\" onfocusout='AddNewAccountInputRow()' />";
}

// Fiexed layout by Jquery for save, delete
function layer_open(el){
    var temp = $('#' + el);
    var bg = temp.prev().hasClass('bg');

    if(bg){
            $('.layer').fadeIn();
    }else{
            temp.fadeIn();
    }

    if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
    else temp.css('top', '0px');
    if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
    else temp.css('left', '0px');

    temp.find('a.cbtn').click(function(e){
            if(bg){
                    $('.layer').fadeOut();
            }else{
                    temp.fadeOut();
            }
            e.preventDefault();
    });

    $('.layer .bg').click(function(e){
            $('.layer').fadeOut();
            e.preventDefault();
    });
}

// Selecet and hidden div        
// Search business condition
$('#bcsClick').on('click',function(){
    if($('#search_business_condition').css('display')!=='none'){$('#search_business_condition').hide();}
    else{$('#search_business_condition').show();}});

//
function ChangeColor(tableRow, highLight){
   if (highLight){tableRow.style.backgroundColor = '00CCCC';}
   else{tableRow.style.backgroundColor = 'white';}};
   
// To Do - check cell innertext
function SetBusinessCondition(condition, type)
{
     var Row = document.getElementById("business_condition");
     var Cells = Row.getElementsByTagName("td");
     Cells[1].innerText=
             "<input class=\"field\" type=\"text\" name=\"bc_name\" placeholder=\"click search button\"\\n\
readonly id=\"bc_name\" value\""+content+"\" size=\"23\" />";
    Cells[3].innerText=
            "<input class=\"field\" type=\"text\" name=\"bc_name\" placeholder=\"click search button\"\\n\
readonly id=\"bc_name\" value=\""+type+"\" size=\"23\" />";
}

// When dbl click business number of result div then send number to request
function submitBusinessNumber(elm) {
    var form = document.resultquery_form;
    form.bc_number_hidden.value = elm.value;
    
    form.submit();
}

// When dbl click custom name of result div then send name to request
function submitCustomName(elm) {
    var form = document.resultquery_form;
    form.bc_name_hidden.value = elm.value;
    
    form.submit();
}

// Clear all contents of custom, not save or delete on database
function initialize()
{
    var input_boxes = document.getElementsByClassName("field");
    var boxes=document.getElementsByClassName("field");
        [].forEach.call(boxes, function(elem, index, arr){
            console.log("Index "+index.toString()+" Value : "+elem.value);
            elem.value="";
        });
}

// Reorder html and show print window
function printDocument()
{
    var before = document.body.innerHTML;
//    alert(body);
    var printArea = document.getElementById("business_number_div").innerHTML;
    printArea = printArea.concat(document.getElementById("important_info_div").innerHTML);
    printArea = printArea.concat(document.getElementById("Other_info_div").innerHTML);
    printArea = printArea.concat(document.getElementById("account_detail_div").innerHTML);
//    alert(printArea);
    document.body.innerHTML = printArea;
    window.print();
    Document.body.innerHTML = before;
    
}

// Submit after confirm
function submitAfterConfirm(){
    var form = document.getcontent_form;
    var bAct = window.confirm("진짜로 하시겠습니까?");
    
    if(bAct)
        form.submit();
}