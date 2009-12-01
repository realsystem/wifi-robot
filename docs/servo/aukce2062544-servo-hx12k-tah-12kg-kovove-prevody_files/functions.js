	var browserOK = true;
	var dailyshow = false;
	var justnow = new Date ();
	var diff; var expir;
	diff = 1000 * (86400 - 3600 * justnow.getHours () - 60 * justnow.getMinutes () - justnow.getSeconds ());
	expir = new Date (justnow.getTime () + diff);
	document.cookie = "dailyseen=on;expires=" + expir.toGMTString ();
	if (document.cookie.indexOf ("dailyseen=on") > -1) dailyshow = true;

  function set_cookie(name, value, expires, path, domain, secure) {
    var expires_date = new Date(expires);

    document.cookie = name + "=" + escape(value) +
    ((expires) ? ";expires=" + expires_date.toGMTString() : "") +
    ((path) ? ";path=" + path : "") +
    ((domain) ? ";domain=" + domain : "" ) +
    ((secure) ? ";secure" : "");
  }

/*
  function get_cookie(name) {
  	var nameEQ = name + "=";
  	var ca = document.cookie.split(';');
  	for(var i = 0; i < ca.length; i++) {
  		var c = ca[i];
  		while(c.charAt(0) == ' ') c = c.substring(1, c.length);
  		if(c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length, c.length));
  	}
  	return null;
  }
*/

  function get_cookie(name) {
    var start = document.cookie.indexOf(name + "=");
    var len = start + name.length + 1;
    if((!start) && (name != document.cookie.substring(0, name.length))) return null;
    if(start == -1) return null;
    var end = document.cookie.indexOf(";", len);
    if(end == -1) end = document.cookie.length;
    return unescape( document.cookie.substring(len, end));
  }

  function delete_cookie(name, path, domain) {
    if(get_cookie(name)) document.cookie = name + "=" +
      ((path) ? ";path=" + path : "") +
      ((domain) ? ";domain=" + domain : "") +
      ";expires=Thu, 01-Jan-1970 00:00:01 GMT";
  }

	function new_window(adress) {
 		window.open(adress,"","");
 	}

	function popup_window(adress,sirka,vyska,centrovat,pozice_l,pozice_h) {
	  if (centrovat == 1) {
			so = screen.width;
			vo = screen.height;
			zleva = ((so - sirka) / 2) - 13;
	//		shora = (vo - vyska) / 2;
			shora = 100;
		} else {
		  zleva = pozice_l;
		  shora = pozice_h;
		}
	  popup_win = window.open(adress,"popup_okno","width="+sirka+",height="+vyska+",left="+zleva+",top="+shora+",location=1,menubar=1,resizable=1,scrollbars=1,status=1,titlebar=1,toolbar=1");
	  popup_win.resizeTo(sirka+75,vyska+100);
	  popup_win.focus();

  	}
	function popup_window2(adress,sirka,vyska,centrovat,pozice_l,pozice_h) {
	  if (centrovat == 1) {
			so = screen.width;
			vo = screen.height;
			zleva = ((so - sirka) / 2) - 13;
			shora = (vo - vyska) / 2;
		} else {
		  zleva = pozice_l;
		  shora = pozice_h;
		}
	  popup_win = window.open(adress,"popup_okno","width="+sirka+",height="+vyska+",left="+zleva+",top="+shora+",location=0,menubar=0,resizable=1,scrollbars=1,status=0,titlebar=0,toolbar=0");
	  popup_win.resizeTo(sirka+100,vyska+125);
	  popup_win.focus();

  	}
		

	function checkcompany() {
		document.getElementById('company').disabled = !(document.getElementById('companycheck').checked);
		document.getElementById('ico').disabled = !(document.getElementById('companycheck').checked);
		document.getElementById('dic').disabled = !(document.getElementById('companycheck').checked);
		document.getElementById('dph').disabled = !(document.getElementById('companycheck').checked);
		if ((document.getElementById('companycheck').checked)&&(document.getElementById('company').value=="Spolecnost")) {
			document.getElementById('company').value="";
		}
	}	

	
//  inc/ins-item-4.php functions
	function DisableSTime() {
			document.getElementById("date").disabled = !(document.getElementById("latter").checked);
			document.getElementById("hours").disabled = !(document.getElementById("latter").checked);
			document.getElementById("minutes").disabled = !(document.getElementById("latter").checked);
	}
	
	function DisableBuyNow() {
			document.getElementById("buy_price").disabled = !(document.getElementById("buy_price_check").checked);
	}
	
	function DisableMinStep() {
			document.getElementById("min_step").disabled = !(document.getElementById("min_step_check").checked);
	}
	
	function ItemType(itype) {
    switch(itype) {
      case 0:
        document.getElementById("start_price").disabled = false;
      //  document.getElementById("min_price").disabled = false;
        document.getElementById("min_step_check").disabled = false;
			  document.getElementById("min_step").disabled = !(document.getElementById("min_step_check").checked);
        document.getElementById("buy_price_check").disabled = false;
			  document.getElementById("buy_price").disabled = !(document.getElementById("buy_price_check").checked);
        document.getElementById("buy_pieces").disabled = true;
        break;
      case 1:
        document.getElementById("start_price").disabled = true;
       // document.getElementById("min_price").disabled = true;
        document.getElementById("min_step_check").disabled = true;
        document.getElementById("min_step").disabled = true;
        document.getElementById("buy_price_check").disabled = true;
        document.getElementById("buy_price_check").checked = true;
        document.getElementById("buy_price").disabled = false;
        document.getElementById("buy_pieces").disabled = false;
        break;
    }
	}

	function DisableRegion() {
		if ((document.getElementById('country').value)=="54") {
			(document.getElementById('region').disabled)=false;
		}
		if ((document.getElementById('country').value)!="54") {
			(document.getElementById('region').disabled)=true;
		} 
	}

	function enableMyUser(){
		document.getElementById('myuser').disabled = !(document.getElementById('myradio').checked)
	}

	function changePicture(kategorie,id){
		document.getElementById('first_img').src = "//img0.odklepnuto.cz/image.php?mode=item&size=big&id="+id; 
	}
	
	function open_img(centrovat,pozice_l, pozice_h) {
		adress="image-view.php?id="+oid;
		if (centrovat == 1) {
			so = screen.width;
			vo = screen.height;
			zleva = ((so - sirka) / 2) - 13;
			shora = (vo - vyska) / 2;
		} else {
			zleva = pozice_l;
			shora = pozice_h;
		}
			popup_win = window.open(adress,"popup_okno","width="+sirka+",height="+vyska+",left="+zleva+",top="+shora+",location=0,menubar=0,resizable=1,scrollbars=1,status=0,titlebar=0,toolbar=0");
			popup_win.resizeTo(sirka+75,vyska+100);
			popup_win.focus();
		}
				
		
	function disableInsItem() {
		DisableSTime();
		DisableBuyNow();
//		DisableMinStep();
//		DisableRegion();
	}
	
	function filter(lnk, cats, actpage, filterlist, sortlist, dirlist, c1, c2, other){
 		s="?";
		if(cats.toString()!="") {lnk+=s+"cats="+cats.toString();s="&";}
		if(actpage.toString()!="") {lnk+=s+"actpage="+actpage.toString();s="&";}
		if(filterlist.toString()!="") {lnk+=s+"filter="+filterlist.toString();s="&";}
		if(sortlist.toString()!="") {lnk+=s+"sort="+sortlist.toString();s="&";}
		if(dirlist.toString()!="") {lnk+=s+"dir="+dirlist.toString();s="&";}
		if(c1.toString()!="") {lnk+=s+"c1="+c1.toString();s="&";}
		if(c2.toString()!="") {lnk+=s+"c2="+c2.toString();s="&";}
		if(other.toString()!="") {lnk+=s+other.toString();s="&";}
		location.href=lnk;
	}

	var checked=0;
	function chooseFeedback(form, str) {
    if(form) {
			for(var i=0;i<form.length;i++) {
				if(form[i].type=='checkbox' && (str==null || form[i].name.indexOf(str)==0)) form[i].checked=!form[i].checked;
			}
		}
	}

	function aktivuj_box(box) {
		box.style.border="1px solid #838383";
	 	box.style.backgroundColor="#F6F6F6";
	}
	
	function deaktivuj_box(box) {
		box.style.border="1px solid #C9C9C9";
		box.style.backgroundColor="#FFFFFF";
	}

  function set_protocol(ssl) {
    f = document.getElementById('loginform');
    if(ssl) { s1 = /^http:/; s2 = 'https:'; }
    else { s1 = /^https:/; s2 = 'http:'; }
    f.action = f.action.replace(s1, s2);
  }

  function save_scroll_pos(scroll_data_id) {
    if(scroll_data_id) {
      var today = new Date();
      //var scrollx = typeof window.pageXOffset != 'undefined' ? window.pageXOffset : document.documentElement.scrollLeft;
      var scrolly = typeof window.pageYOffset != 'undefined' ? window.pageYOffset : document.documentElement.scrollTop;
      set_cookie('scroll_data', scroll_data_id + ':' + scrolly, today.getTime() + 30 * 60 * 1000, '/', '', 0);
    }
  }

  function load_scroll_pos(scroll_data_id) {
    if(scroll_data_id) {
      data = get_cookie('scroll_data');
      if(data) {
        params = data.split(':');
        if(params[0] == scroll_data_id) window.scrollTo(0, params[1]);
      }
    }
  }
