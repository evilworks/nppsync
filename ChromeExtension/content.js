// This file is part of NppSync plugin by DUzun (original version by evilworks).
// Licence: Public Domain.

!function $_nppsync(win,doc,O,A,F,S,N,U) {

    'nppSyncInjected' in win || (win.nppSyncInjected = 0);
    nppSyncInjected++;
    if (nppSyncInjected > 1) return ;

    var API = {};

    function now() { return (new Date).getTime() };

    function log() { console.log.apply(console, arguments); }; // for developping only!
    
    function getLocalLinks(h,r) {
        var i, l, e, t, q, p;
        r || (r = {});
        for (i = 0, l = h.length; i < l; i++) {
            e = h[i];
            if ( (t = e[p='href']) || (t = e[p='src']) ) {
                if(r instanceof A) r[r.length] = e; else
                if(r instanceof F) {
                    q = r.call(e,i,t,p); 
                    if(q === false) return r;
                } else {
                    if(q = r[t]) q[q.length] = e;
                    else r[t] = [e];
                }
            }
        }
        return r
    }
    
    API.getResources = function getResources(message, sendResponse) {
        var r = {}, 
            cat = message.categorize;
        var t = now();
        if(cat) {
            r.styles = O.keys(getLocalLinks(doc.styleSheets));
            r.scripts = O.keys(getLocalLinks(doc.scripts));
        } else {
            getLocalLinks(doc.styleSheets, r);
            getLocalLinks(doc.scripts, r);
            r = O.keys(r);
        }
        sendResponse(r);    
    };
    
    API.getScripts = function getScripts(message, sendResponse) {
        var a = O.keys(getLocalLinks(doc.scripts));
        sendResponse(O.keys(a));    
    };
    
    API.getStyle = function getStyle(message, sendResponse) {
        var a = O.keys(getLocalLinks(doc.styleSheets));
        sendResponse(O.keys(a));    
    };

    API.updateStyle = function updateStyle(message, sendResponse) {
        var u = message.url;
        var v = message.hash;
        var a = O.keys(getLocalLinks(doc.styleSheets, function (idx, url, prop) {
            if(url && url.indexOf(u) === 0) {
                url = url.replace(/(\?|&)v=[^&]+/, '');
                url += (url.indexOf('?') < 0 ? '?' : '&') + 'v=' + v;
                try{this[prop]=url}catch(err){}
                try{this.ownerNode[prop]=url}catch(err){}
            }
        }));
        sendResponse && sendResponse(a);    
    };    
    
    chrome.extension.onMessage.addListener( function(message, sender, sendResponse) {
        if(typeof message == 'string') {
            message = { api: message };
        }
        var clb = message.api;
        if(typeof API[clb] == 'function') {
            API[clb].call(sender, message, sendResponse);
        } else {
            sendResponse(new Error('Unknown message "'+clb+'" in content.js'));
        }
    } );
}(window, document, Object, Array, Function, String, Number);
