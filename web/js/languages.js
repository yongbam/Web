/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
// 언어팩 선언.
$.lang = {};

$.lang['ko'] = {
    query_bt: '조회',
    save_bt: '저장',
    close_bt: '닫기',
    print_bt: '화면출력',
    init_bt: '초기화',
    delete_bt: '삭제',
    setup_bt: '화면설정'
};

$.lang['en'] = {
    query_bt: 'Query',
    save_bt: 'Save',
    close_bt: 'Close',
    print_bt: 'Print',
    init_bt: 'Init',
    delete_bt: 'Delete',
    setup_bt: 'Setup'
};

$.lang['ja'] = {
    query_bt: 'クエリ-',
    save_bt: 'セ-ブ',
    close_bt: 'クロ-ズ',
    print_bt: '畵面出力',
    init_bt: '初期化',
    delete_bt: 'デリ-ト',
    setup_bt: '設定'
};

/**
* setLanguage 
* use $.lang[currentLanguage][languageNumber]
*/
function setLanguage(currentLanguage) {
//    console.log('setLanguage', arguments);
    console.log('setLanguage : ' + currentLanguage);
    $('[data-langNum]').each(function() {
        var $this = $(this); 
        this.value=$.lang[currentLanguage][$(this).attr("data-langNum")];
//        $this.html($.lang[currentLanguage][$this.data('langnum')]); 
    });
}  

// 언어 변경
$(document).ready(function(){    
    $('.lang_button').click(
            function() {
//                var lang = $(this).data('lang');
                var lang = $(this).attr("data-lang");
                setLanguage(lang); 
            });
        });
