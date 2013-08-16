/**
 * NppSync JS API and tools.
 *
 * @Author Dumitru Uzun (DUzun)
 *
 */

(function $_nppSync(win,doc,O,A,F,S,N,U) {
    var hop = O.hasOwnProperty
        , def = {
            serverPort: 40500
            , serverName: 'localhost'
            , pingInterval: 1e3
            , resourcesInterval: 15e3
          }
        , prot = {
            map: U
            , opt : def
          }
        , DS = '\\'
        , eds = /[\/\\]+/g 
        , efurl = /^[a-z]+\:\/\/.+/
        ;
        
    function log() { console.log.apply(console, arguments); } // for developping only!
    win.log = log;    
        
    function each(o, f) {
        if(!o) return o;
        var i, s, l = 'length';
        if(o instanceof A || hop.call(o, l) && typeof o[l] == 'number') {
            for(i=0,l=o[l]>>>0; i<l; i++) if(hop.call(o, i)) {
                s = o[i];
                if(f.call(s, i, s) === false) return i;
            }
        } else {
            for(i in o) if(hop.call(o, i)) {
                s = o[i];
                if(f.call(s, i, s) === false) return i;
            }
        }
        return o;
    } 
    
    function isEmpty(obj) {
        var ret = true;
        each(obj, function () { return ret = false; });
        return ret;
    } 
    
    
    function extend(o) {
        function cpy(i,s) { o[i] = s; }
        each(arguments, function (i,a) { if(i) each(a, cpy); });
        return o;
    } 
    
    function eachdef(f) { return each(def, f); }
    
    function now() { return (new Date()).getTime(); }

    function $byid(id) { return doc.getElementById(id); }
    function $byname(form,name) {
        if( (form = doc[form]) && (form = form.elements) &&  (name = form[name]) ) return name;
    } 
    
    /// Parse URL (by DUzun)
    function url(href,part) {
        var a = url.a;
        if(!a) url.a = a = doc.createElement('A');
        if(href != null) a.href = href;
        return part ? a[part] : a;
    } 
   
    function NppSync() {
        this.opt = {};
        this.map = this.get('map') || [];
        if(!(this.map instanceof Array)) {
            var t = [];
            each(this.map, function (k,v) { t.push([k,v]); });
            this.map = t;
        }
    } 
    
    prot.each    = each   ;
    prot.isEmpty = isEmpty ;
    prot.extend  = extend ;
    prot.now     = now ;
    prot.eachdef = eachdef;
    prot.url     = url    ;
    prot.$       = $byid  ;
    prot._       = $byname;

    prot.get = function get(n, l) {
        var self = this, o = self.opt, v;
        if(n == U) {
            v = {};
            each(def, function (n,s) {
                v[n] = get.call(self, n, l);
            });
            return v;
        }
        if(!l && hop.call(o, n)) return o[n];
        if(n in localStorage) {
            v = localStorage[n];
            if(v) v = JSON.parse(v);
            o[n] = v;
            return v;
        }
        return def[n];
    } ;
    
    prot.set = function set(n, v) {
        var o = this.opt;
        function ass(n,v) {
            if(def[n] === v) {
                delete o[n];
                delete localStorage[n];
            } else {
                o[n] = v;
                localStorage[n] = JSON.stringify(v);
            }
        }
        if(n instanceof O) each(n, ass); else ass(n,v);
    } ;
    
    prot.reset = function reset(n) {
        var o = this.opt;
        function del(n) {
            delete o[n];
            delete localStorage[n];
        }
        return n == U ? each(def, del) : del(n);
    } ;
    
    prot.rootpath = function rootpath(url) {
        if(!efurl.test(url)) return false;
        var self = this, 
            root;
        url = self.url(url);
        switch(url.protocol) {
            case 'file:':
                root = '';
            break;
            
            case 'http:':  /*falls through*/
            case 'https:': /*falls through*/
            default: {
                var map = self.get('map');
                url = url.origin + url.pathname;
                self.each(map, function (i, a, u, f) {
                    if(url.indexOf(u = a[0]) === 0) {
                        f = a[1];
                        if(f.substr(f.length-1) != DS) f += DS;
                        root = f.replace(eds, DS);
                        return false;
                    }
                });
            }
        }
        return root;
    } ;
    
    prot.filepath = function filepath(url) {
        if(!efurl.test(url)) return false;
        var self = this, 
            file;
        url = self.url(url);
        switch(url.protocol) {
            case 'file:':
                file = url.pathname.substr(1).replace(eds, DS);
            break;
            
            case 'http:':  /*falls through*/
            case 'https:': /*falls through*/
            default: {
                var map = self.get('map');
                url = url.origin + url.pathname;
                self.each(map, function (i, a, u, f) {
                    if(url.indexOf(u = a[0]) === 0) {
                        f = a[1];
                        if(f.substr(f.length-1) != DS) f += DS;
                        file = (f + url.substr(u.length)).replace(eds, DS);
                        return false;
                    }
                });
            }
        }
        return file;
    } ;
    
    prot.request = function request(r, success, error) {
        var self = this,
            x = new XMLHttpRequest();
        
        if(typeof r == 'string') {
            r = encodeURIComponent(r);
        } else {
            r = '???';
        }
        
        x.open("GET", "http://"+self.get('serverName')+":"+self.get('serverPort')+"/" + r, true);
        x.onreadystatechange = function() {
            if (x.readyState == 4) {
                if(x.status == 200) {
                    if(success instanceof F) success.call(self, x.responseText, x);
                } else {
                    if(error instanceof F) error.call(self, x.statusText, x);
                }
            }
        };
        try {
            x.send();
        } catch (err) {
            if(error instanceof F) error.call(self, err, x);
            return false;
        }
        return x;       
    } ;
    
    NppSync.prototype = prot;
    
    win.NppSync = NppSync;
    
    win.nppsync = new NppSync();
    
}
(window, document, Object, Array, Function, String, Number));