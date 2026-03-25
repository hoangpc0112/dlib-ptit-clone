/*
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
/*
 * Utility Javascript methods for DSpace
 */

// Popup window - here so it can be referred to by several methods
var popupWindow;

// =========================================================
//  Methods for e-person popup window
// =========================================================

// Add to list of e-people on this page -- invoked by eperson popup window
function addEPerson(id, email, name)
{
    var newplace = window.document.epersongroup.eperson_id.options.length;

    if (newplace > 0 && window.document.epersongroup.eperson_id.options[0].value == "")
    {
        newplace = 0;
    }

    // First we check to see if e-person is already there
    for (var i = 0; i < window.document.epersongroup.eperson_id.options.length; i++)
    {
        if (window.document.epersongroup.eperson_id.options[i].value == id)
        {
            newplace = -1;
        }
    }

    if (newplace > -1)
    {
        window.document.epersongroup.eperson_id.options[newplace] = new Option(name + " (" + email + ")", id);
    }
}

// Add to list of groups on this page -- invoked by eperson popup window
function addGroup(id, name)
{
    var newplace = window.document.epersongroup.group_ids.options.length;

	if (newplace > 0 && window.document.epersongroup.group_ids.options[0].value == "")
    {
        newplace = 0;
    }

    // First we check to see if group is already there
    for (var i = 0; i < window.document.epersongroup.group_ids.options.length; i++)
    {
        // is it in the list already
        if (window.document.epersongroup.group_ids.options[i].value == id)
        {
            newplace = -1;
        }

        // are we trying to add the new group to the new group on an Edit Group page (recursive)
        if (window.document.epersongroup.group_id)
        {
            if (window.document.epersongroup.group_id.value == id)
            {
                newplace = -1;
            }
        }
    }

    if (newplace > -1)
    {
        window.document.epersongroup.group_ids.options[newplace] = new Option(name + " (" + id + ")", id);
    }
}

// This needs to be invoked in the 'onClick' javascript event for buttons
// on pages with a dspace:selecteperson element in them
function finishEPerson()
{
    selectAll(window.document.epersongroup.eperson_id);

	if (popupWindow != null)
	{
		popupWindow.close();
	}
}

// This needs to be invoked in the 'onClick' javascript event for buttons
// on pages with a dspace:selecteperson element in them
function finishGroups()
{
    selectAll(window.document.epersongroup.group_ids);

    if (popupWindow != null)
    {
		popupWindow.close();
    }
}

// =========================================================
//  Miscellaneous utility methods
// =========================================================

// Open a popup window (or bring to front if already open)
function popup_window(winURL, winName)
{
    var props = 'scrollBars=yes,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=640,height=480';
    popupWindow = window.open(winURL, winName, props);
    popupWindow.focus();
}


// Select all options in a <SELECT> list
function selectAll(sourceList)
{
    for(var i = 0; i < sourceList.options.length; i++)
    {
        if ((sourceList.options[i] != null) && (sourceList.options[i].value != ""))
            sourceList.options[i].selected = true;
    }
    return true;
}

// Deletes the selected options from supplied <SELECT> list
function removeSelected(sourceList)
{
    var maxCnt = sourceList.options.length;
    for(var i = maxCnt - 1; i >= 0; i--)
    {
        if ((sourceList.options[i] != null) && (sourceList.options[i].selected == true))
        {
            sourceList.options[i] = null;
        }
    }
}


// Disables accidentally submitting a form when the "Enter" key is pressed.
// Just add "onkeydown='return disableEnterKey(event);'" to form.
function disableEnterKey(e)
{
     var key;

     if(window.event)
          key = window.event.keyCode;     //Internet Explorer
     else
          key = e.which;     //Firefox & Netscape

     if(key == 13)  //if "Enter" pressed, then disable!
          return false;
     else
          return true;
}


//******************************************************
// Functions used by controlled vocabulary add-on
// There might be overlaping with existing functions
//******************************************************

function expandCollapse(node, contextPath) {
	node = node.parentNode;
	var childNode  = (node.getElementsByTagName("ul"))[0];

	if(!childNode) return false;

	var image = node.getElementsByTagName("img")[0];
	
	if(childNode.style.display != "block") {
		childNode.style.display  = "block";
		image.src = contextPath + "/image/controlledvocabulary/m.gif";
		image.alt = "Collapse search term category";
	} else {
		childNode.style.display  = "none";
		image.src = contextPath + "/image/controlledvocabulary/p.gif";
		image.alt = "Expand search term category";
	}
	
	return false;
}


function getAnchorText(ahref) {
 	if(isMicrosoft()) return ahref.childNodes.item(0).nodeValue;
	else return ahref.text;
}

function getTextValue(node) {
 	if(node.nodeName == "A") {
 		return getAnchorText(node);
 	} else {
 		return "";
 	}
 	
}


function getParentTextNode(node) {
	var parentNode = node.parentNode.parentNode.parentNode;
	var children = parentNode.childNodes;
	var textNode;
	for(var i=0; i< children.length; i++) {
		var child = children.item(i);
		if(child.className == "value") {
			return child;
		}
	}
	return null;
}

function ec(node, contextPath) {
	expandCollapse(node, contextPath);
	return false;
}


function i(node) {
	return sendBackToParentWindow(node);
}


function getChildrenByTagName(rootNode, tagName) {
	var children = rootNode.childNodes;
	var result = new Array(0);
	if(children == null) return result;
	for(var i=0; i<children.length; i++) {
		if(children[i].tagName == tagName) {
			var elementArray = new Array(1);
			elementArray[0] = children[i];
			result = result.concat(elementArray);
		}
	}
	return result;
}

function popUp(URL) {
	var page;
	page = window.open(URL, 'controlledvocabulary', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=650,height=450');
}


function isNetscape(v) {
		  return isBrowser("Netscape", v);
}
	
function isMicrosoft(v) {
		  return isBrowser("Microsoft", v);
}

function isMicrosoft() {
		  return isBrowser("Microsoft", 0);
}


function isBrowser(b,v) {
		  browserOk = false;
		  versionOk = false;

		  browserOk = (navigator.appName.indexOf(b) != -1);
		  if (v == 0) versionOk = true;
		  else  versionOk = (v <= parseInt(navigator.appVersion));
		  return browserOk && versionOk;
}
function showHideToggle(divID) {
   if (document.getElementById && !document.all) {
       previewBox = document.getElementById(divID);
       var state = previewBox.style.display;
       if (state == 'block') {state = 'none';} else {state = 'block';}
       previewBox.style.display = state;
   }
}

function urlencode(str) {
    return escape(str).replace(/\+/g,'%2B').replace(/%20/g, '+').replace(/\*/g, '%2A').replace(/\//g, '%2F').replace(/@/g, '%40');
}

String.prototype.endsWith = function(str)
{
    return (this.match(str+"$")==str)
}
var Base64 = {


    _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",


    encode: function(input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;

        input = Base64._utf8_encode(input);

        while (i < input.length) {

            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);

            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;

            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }

            output = output + this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);

        }

        return output;
    },


    decode: function(input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;

        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

        while (i < input.length) {

            enc1 = this._keyStr.indexOf(input.charAt(i++));
            enc2 = this._keyStr.indexOf(input.charAt(i++));
            enc3 = this._keyStr.indexOf(input.charAt(i++));
            enc4 = this._keyStr.indexOf(input.charAt(i++));

            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;

            output = output + String.fromCharCode(chr1);

            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }

        }

        output = Base64._utf8_decode(output);

        return output;

    },

    _utf8_encode: function(string) {
        string = string.replace(/\r\n/g, "\n");
        var utftext = "";

        for (var n = 0; n < string.length; n++) {

            var c = string.charCodeAt(n);

            if (c < 128) {
                utftext += String.fromCharCode(c);
            }
            else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            }
            else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }

        }

        return utftext;
    },

    _utf8_decode: function(utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;

        while (i < utftext.length) {

            c = utftext.charCodeAt(i);

            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            }
            else if ((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i + 1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            }
            else {
                c2 = utftext.charCodeAt(i + 1);
                c3 = utftext.charCodeAt(i + 2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }

        }

        return string;
    }

}
var encode = document.getElementById('encode'),
    decode = document.getElementById('decode'),
    output = document.getElementById('output'),
    input = document.getElementById('input');
	locat = location.hostname;
	urldspace= "http://"+locat+":8080";



function setPreviewSource(source) {
         input = source;
	output = Base64.encode(input);
        source = urldspace+"/media/demo/mediaelementplayer.php?"+output;


    $("#embed").attr("src", source); //requires jQuery
    showHideToggle('preview');
    // and toggle
}
function setPreviewSourcemp3(source) {
		input = source;
	output = Base64.encode(input);
        source = urldspace+"/media/demo/mediaelementplayer-audio.php?"+output;

    $("#embed").attr("src", source); //requires jQuery
    showHideToggle('preview');
    // and toggle
}
function setPreviewSourceHide(source) {
source="";
    $("#embed").attr("src", source); //requires jQuery
    showHideToggle('preview');
    // and toggle
}
function loadView(source){
	input = source;
	output = Base64.encode(input);
	window.open(urldspace+"/php/download.php?"+output);
}
function loadViewOffice(source){
	input = source;
	output = Base64.encode(input);
	window.open(urldspace+"/php/downloads.php?"+output);
}
function loadViewImg(source){
	input = source;
	output = Base64.encode(input);
	window.open(urldspace+"/viewerjs/view/?"+output);
}	

document.onkeyup = function(evt) {
    evt = evt || window.event;
    if (evt.keyCode == 27) {
        source="";
    $("#embed").attr("src", source); //requires jQuery
    showHideToggle('preview');
    // and toggle

    }
}
