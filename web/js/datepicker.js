/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/* For load date picker for IE - IE yet couldn't support all components of HTEML5 */
$(function() {
    $( '#contract_start' ).datepicker({
        dateFormat: "yy-mm-dd"
    });
    $( '#contract_end' ).datepicker({
        dateFormat: "yy-mm-dd"
    });    
});


