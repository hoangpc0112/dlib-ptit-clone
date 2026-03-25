/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/* global $purcUrl, bootbox, $gError200Login, $gCancelBtnText, $handle */

var $divloaded = false;

$(document).ready(function () {
    
    if (!$divloaded) loadPurcDiv($("#purc-addon-div"));
});

function loadPurcDiv($purcdiv){
    $.ajax({
            url: $purcUrl,
            data: {
                'action': 'loadaddonform', handle: $handle
            },
            context: this,
            dataType: 'html'
    }).done(function (htmlData) {
        $($purcdiv).empty();
        $purcdiv.append(htmlData);
        $purcdiv.find('.btn-add-to-wl').click(function (e) {
            e.preventDefault();
            $.ajax({
                url: $purcUrl,
                data: {
                    'action': 'addtowl', handle: $handle
                },
                dataType: 'json',
                type: 'POST'
            }).done(function (data) {
                bootbox.hideAll();
                loadPurcDiv($purcdiv);
            }).fail(function (jqxhr) {
                bootbox.alert(jqxhr.responseText);
                console.log(jqxhr);
            });
        });
        $purcdiv.find('.btn-rem-fr-wl').click(function (e) {
            e.preventDefault();
            $.ajax({
                url: $purcUrl,
                data: {
                    'action': 'deletewli', handle: $handle
                },
                dataType: 'json',
                type: 'POST'
            }).done(function (data) {
                bootbox.hideAll();
                loadPurcDiv($purcdiv);
            }).fail(function (jqxhr) {
                bootbox.alert(jqxhr.responseText);
                console.log(jqxhr);
            });
        });
        $purcdiv.find('.btn-buy').click(function (e) {
            e.preventDefault();
            $.ajax({
                url: $purcUrl,
                data: {
                    'action': 'addtocart', 'priceid': $(this).attr('data-priceid'), handle: $handle
                },
                dataType: 'json',
                type: 'POST'
            }).done(function (data) {
                bootbox.hideAll();
                loadPurcDiv($purcdiv);
            }).fail(function (jqxhr) {
                bootbox.alert(jqxhr.responseText);
                console.log(jqxhr);
            });
        });
        $purcdiv.find('.btn-unbuy').click(function (e) {
            e.preventDefault();
            $.ajax({
                url: $purcUrl,
                data: {
                    'action': 'removetransaction', 'transactionid': $(this).attr('data-transactionid'), handle: $handle
                },
                context: this,
                dataType: 'json',
                type: 'POST'
            }).done(function (data) {
                bootbox.hideAll();
                loadPurcDiv($purcdiv);
            }).fail(function (jqxhr) {
                bootbox.alert(jqxhr.responseText);
                console.log(jqxhr);
            });
        });
    });
    $divloaded=true;
}