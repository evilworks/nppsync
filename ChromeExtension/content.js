// This file is part of NppSync plugin by DUzun (original version by evilworks).
// Licence: Public Domain.

!function $_nppsync(win,doc,O,A,F,S,N,U) {

    'nppSyncInjected' in win || (win.nppSyncInjected = 0);
    nppSyncInjected++;
    if (nppSyncInjected > 1) return ;

    var API = {};

    function now() { return (new Date).getTime() };

    function log() { console.log.apply(console, arguments); }; // for developping only!

    function getLocalLinks(h,r,o) {
        r || (r = {});
        for (var i = 0, l = h.length, e, t, q; i < l; i++) {
            e = h[i];
            if ( (t = e.href) || (t = e.src) ) {
                if(q = r[t]) q[q.length] = e;
                else r[t] = [e];
                if(o) o[o.length] = e;
            }
        }
        return r
    }

    API.getResources = function getResources(sender, sendResponse) {
        var r = {}, a;
        var t = now();
        getLocalLinks(doc.styleSheets, r);
        getLocalLinks(doc.scripts, r);
        a = O.keys(r);
        sendResponse(a);
    }

    chrome.extension.onMessage.addListener( function(message, sender, sendResponse) {
        if(typeof API[message] == 'function') {
            API[message].call(API, sender, sendResponse);
        } else {
            sendResponse(new Error('Unknown message "'+message+'" in content.js'));
        }
    } );
}(window, document, Object, Array, Function, String, Number);
