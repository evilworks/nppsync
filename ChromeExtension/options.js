(function $_(win,doc,O,A,F,S,N,$,ny,U) {
    $  = win.jQuery;
    ny = win.nppsync;
    
    function showStatus(s) {
        var st = $('#status');
        st.html(s).show();
        setTimeout(function() {
            st.fadeOut();
        }, 3e3);
    }

    function saveSettings() {
        ny.each(doc.forms.opt.elements, function (i, e, v) {
            if(e.name) {
                v = $.trim(e.value||'');
                if(!isNaN(v)) v = +v;
                ny.set(e.name, v);
            }
        });
        
        var map = [], 
            idx = 0,
            r = function (tr, nm, hd) {
                    var kd = tr.find('.'+nm),
                        t = kd.find('input:first'), k;
                    if(t.length) {
                        k = $.trim(t.val());
                        tr.find('[name='+nm+']').text(k);
                        if ( hd ) t.hide();
                    } else {
                        k = $.trim(kd.text());
                    }                
                return k;
            } ;
            
        
        $(doc.forms.map.elements).each(function (i, e) {
            if(e.name == 'value') {
                var tr = $(e).closest('tr'), k, v, x, t;
                if(!tr.is(':visible')) return;
                
                k = r(tr, 'key', true);
                v = r(tr, 'value', false);
                x = parseFloat(r(tr, 'idx', false));

                if(k && v) {
                    map[idx] = [k,v];
                    map[idx].x = x;
                    ++idx;
                } else {
                    tr.remove();
                }
            }
        });
        map.sort(function (a,b){return a.x - b.x;});
        ny.set('map', map);
        
        showStatus("Settings saved.");
    }

    function addMapRow(k,v) {
        var o = {key: '', value: '', idx: ''},
            row, t;
        if(k != null) {
            if(v instanceof Array) {
                o.key = v[0];
                o.value = v[1];
                o.idx = k;
            } else if(v) {
                o.key = k;
                o.value = v;
            } else return ;
        }
        row = $(ny.parse_tpl(ny.tpl.map_row, o));
        if(k == null) {
            t = $('<input type="text" name="key" value="" />');
            row.find('.key').append(t);
            // t.on('blur', function () {
                // v = $.trim(t.val());
                // if(v != '') {
                    // row.find('[name=key]').text(v);
                    // t.hide()
                // }
            // });
            $(ny.tple.map_row).after(row);
            row.find(':text:first').focus();
        } else {
            $(ny.tple.map_row).parent().append(row);
        }
        return row;
    }
    
    function loadSettings() {
        ny.each(doc.forms.opt.elements, function (i, e, v) {
            if(e.name) {
                v = $.trim(ny.get(e.name) || '');
                if(isNaN(v)) {
                    e.value = v;
                } else {
                    $(e).counto(v);
                }
            }
        });
        
        var tpl = {}, 
            tple = {};
        $('[data-tpl]').each(function (i,t) {
            t = $(t);
            var n = t.attr('data-tpl');
            tpl[n] = t.show().outerHTML();
            tple[n] = t;
            t.hide();
        });
        
        ny.tpl = tpl;
        ny.tple = tple;
        
        var map = ny.get('map');
        
        if(ny.isEmpty(map)) map = {'http://localhost/' : 'd:\\www\\'};
        // log(map)
        ny.each(map, addMapRow);
    }

    function addAddress(evt) {
        addMapRow(); 
    }
    
    
    function restoreDefaults() {
        var els = doc.forms.opt.elements;
        ny.reset();
        ny.eachdef(function (n, v, e) {
            v = $.trim(ny.get(n)||'');
            e = els[n];
            if(isNaN(v)) {
                e.value = v;
            } else {
                $(e).counto(v);
            }
        });
        showStatus("Defaults restored.");
    }
    
    /* ------------------------------------------------------------------- */
    $(loadSettings);
    $('#restoreDefaults').on('click', restoreDefaults);
    $('#saveSettings').on('click', saveSettings);    
    $('#addAddress').on('click', addAddress);    
    /* ------------------------------------------------------------------- */
    /// (by DUzun)
    $.fn.outerHTML = function() {
        $t = $(this);
        if ('outerHTML' in $t[0]) {
            return $t[0].outerHTML;
        } else {
            var content = $t.wrap('<div></div>').parent().html();
            $t.unwrap();
            return content;
        }
    };

    /// Nice count to nr (by DUzun)
    $.fn.counto = function cto (nr,dl,done) {
        if(!dl) dl = 400;
        var start = $.now(),
            end   = start + dl,
            delay = 10,
            rwm = parseFloat,
            rwc,
            fx = String(nr).split('.');
        if(typeof xNumber == 'function') {
            rwm = xNumber;
            rwc = xNumber;
        }
        fx = fx.length > 1 ? fx[1].length : 0;
        nr = rwm(nr);
        this.each(function (i, e) {
            var $this = $(e),
                data  = $this.data(),
                mh = $this.is(':input') ? 'val' : 'text',
                v =  $this[mh](),
                val   = rwc ? new rwc(v) : rwm(v),
                ofs = Number(val),
                last  = ofs,
                inter = ofs - nr,
                sv = function sv() {
                    if(data._cto) clearTimeout(data._cto);
                    var now = $.now(), v;
                    if(now < end && last != nr) {
                        v = (ofs - (now-start) / dl * inter).toFixed(fx);
                        data._cto = setTimeout(sv, delay);
                    } else {
                        v = fx ? nr.toFixed(fx) : nr;
                        delete data._cto;
                    }
                    if(v != last) {
                        last = v;
                        rwc ? (val.value = v) : (val = v); 
                        $this[mh](val);
                    }
                    if(!data._cto) {
                        if(done instanceof Function) done.call(e, nr, val);
                    }
                } ;
            sv();            
        });
    } ;

    /**
     * Parse a TPL string, replacing %var% with values from vars[%var%]
     *
     * @param (String) str  - template string
     * @param (Object) vars - name-value pairs of variables with values
     *
     * @return (Strnig) parsed template string
     *
     * @author DUzun
     */
    ny.parse_tpl = function parse_tpl(str, vars) {
        var expr = parse_tpl.expr || (parse_tpl.expr = {});
        ny.each(vars, function (s, v, r) {
            r = expr[s];
            if(!r) {
                expr[s] = r = new RegExp('%' + s + '%', 'g');
            }
            str = str.replace(r, v);
        });
        return str;
    } ;    
}
(window, document, Object, Array, Function, String, Number));
