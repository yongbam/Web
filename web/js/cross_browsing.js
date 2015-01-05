/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function getBrowserType(){
        var _ua = navigator.userAgent;
        var rv = -1;

        //IE 11,10,9,8
        var trident = _ua.match(/Trident\/(\d.\d)/i);
        if( trident != null )
        {
            if( trident[1] == "7.0" ) return rv = "IE" + 11;
            if( trident[1] == "6.0" ) return rv = "IE" + 10;
            if( trident[1] == "5.0" ) return rv = "IE" + 9;
            if( trident[1] == "4.0" ) return rv = "IE" + 8;
        }

        //IE 7...
        if( navigator.appName == 'Microsoft Internet Explorer' ) return rv = "IE" + 7;

        /*
        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if(re.exec(_ua) != null) rv = parseFloat(RegExp.$1);
        if( rv == 7 ) return rv = "IE" + 7; 
        */

        //other
        var agt = _ua.toLowerCase();
        if (agt.indexOf("chrome") != -1) return 'Chrome';
        if (agt.indexOf("opera") != -1) return 'Opera'; 
        if (agt.indexOf("staroffice") != -1) return 'Star Office'; 
        if (agt.indexOf("webtv") != -1) return 'WebTV'; 
        if (agt.indexOf("beonex") != -1) return 'Beonex'; 
        if (agt.indexOf("chimera") != -1) return 'Chimera'; 
        if (agt.indexOf("netpositive") != -1) return 'NetPositive'; 
        if (agt.indexOf("phoenix") != -1) return 'Phoenix'; 
        if (agt.indexOf("firefox") != -1) return 'Firefox'; 
        if (agt.indexOf("safari") != -1) return 'Safari'; 
        if (agt.indexOf("skipstone") != -1) return 'SkipStone'; 
        if (agt.indexOf("netscape") != -1) return 'Netscape'; 
        if (agt.indexOf("mozilla/5.0") != -1) return 'Mozilla';
    }