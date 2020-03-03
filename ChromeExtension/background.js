// This file is part of NppSync plugin by evilworks.
// Licence: Public Domain.

function updateIcon(tabId, show, enabled) {
	if (show) {
		chrome.pageAction.show(tabId);
		if (enabled) {
			chrome.pageAction.setIcon({
				tabId : tabId,
				path : "icon_19_enabled.png"
			});
			chrome.pageAction.setTitle({
				tabId : tabId,
				title : "NppSync is enabled."
			});
		} else {
			chrome.pageAction.setIcon({
				tabId : tabId,
				path : "icon_19_disabled.png"
			});
			chrome.pageAction.setTitle({
				tabId : tabId,
				title : "NppSync is disabled."
			});
		}
	} else {
		chrome.pageAction.hide(tabId);
	}
}
var tabData = {};

function log() { console.log.apply(console, arguments); } // for developping only!

function pollResource(tabId, n) {
    nppsync.request(n, function (response) {
        chrome.tabs.get(tabId, function(tab) {
            if (tab !== undefined) {
                var td = tabData[tabId],
                    st = td.categ && td.categ.styles;
                td.checkCount++;
                if (response != td.files[n].hash) {
                    td.files[n].hash = response;
                    if(st && st[n]) {
                        if(!td.styles) td.styles = {};
                        td.styles[n] = response;
                        td.needsStyleUpdate = n;
                    }
                    td.needsReload = response;
                }
                if (td.checkCount == td.filesCount) {
                    if (td.needsReload) {
                        if(td.categ && td.categ.styles) {
                            nppsync.each(td.categ.styles, function (f) {
                                var h = td.files[f];
                                if(h) h = h.hash;
                                if(h == td.needsReload) td.needsReload = false;
                            });
                        }
                        if(td.needsReload) {
                            chrome.tabs.reload(tabId, {bypassCache: true});
                        } else {
                            if(td.styles) {
                                nppsync.each(td.styles, function (f, v) {
                                    chrome.tabs.sendMessage(tabId,
                                        { api: 'updateStyle',
                                          url: td.categ.styles[f],
                                          hash: v },
                                        function (response) {
                                            td.filesTs = 0;
                                        }
                                    );
                                });
                            }
                        }
                    }
                    td.checkCount = 0;
                    td.needsReload = false;
                    if (td.enabled) {
                        window.setTimeout(function() {timerCallback(tabId);}, nppsync.get('pingInterval')||1e3);
                    }
                }
            }
        });
    }, function (error,x) {
        console.log(error,x);
    });
}

function pollResources(tabId, res) {
    var td = tabData[tabId],
        to = 0;
    if(!td) return false;

    td.needsReload = false;
    td.checkCount = 0;
    nppsync.each(res, function (i) {
        setTimeout(function () {
            pollResource(tabId, i);
        }, to += 13);
    });
    return res;
}

function getResources(tabId, clb) {
    if(clb) {
        chrome.tabs.sendMessage(tabId,
            { api: 'getResources', categorize: true },
            function tabMessageRes(response) {
                var td = tabData[tabId],
                    respath = {};

                td.filesCount = 0;
                td.filesTs = nppsync.now();

                nppsync.each(response, function (c, l, cf) {
                    td.categ[c] = cf = {};
                    nppsync.each(l, function (i, h, f) {
                        f = nppsync.filepath(h);
                        if(f) {
                            cf[f] = h;
                            respath[f] = h;
                            if( !td.files[f] ) {
                                td.files[f] = {hash: '0'};
                            }
                        }
                    });
                });

                nppsync.each(td.files, function (i) {
                    if (i != td.tabfile && i != td.tabroot && !(i in respath)) {
                        delete td.files[i];
                    }
                });

                td.filesCount = Object.keys(td.files).length;

                if(clb instanceof Function) clb.call(td, tabId, td.files, td.filesCount);
            }
        );
    }
    return tabData[tabId].files;
}

function timerCallback(tabId) {
    chrome.tabs.get(
        tabId,
        function(tab) {
            if (tab === undefined) return ;

            var td = tabData[tabId];
            if(!td || !td.files || td.filesCount < 2 || nppsync.get('resourcesInterval') < nppsync.now() - td.filesTs) {
                getResources(tabId, pollResources);
            } else {
                pollResources.call(td, tabId, td.files);
            }
        }
    );
}




chrome.tabs.onUpdated.addListener(
    function onTabUpdated(tabId, changeInfo, tab) {
        if (changeInfo.status != "complete") return;

        var tabfile = nppsync.filepath(tab.url);
        if (!tabfile) return;

        var tabroot = nppsync.rootpath(tab.url);
        if (tabData === undefined) updateIcon(false, false);

        var td = tabData[tabId];
        if (td === undefined) {
            tabData[tabId] = td = {
                enabled    : false,
                checkCount : 0,
                filesCount : 0,
                needsReload: false,
                tabfile    : tabfile,
                files      : {},
                categ      : {}
            };
            if(tabroot) td.tabroot = tabroot;
            td.files[tabroot || tabfile] = {hash: '0'};
            td.filesCount = 1;
        }

        td.updateTs = nppsync.now();

        chrome.tabs.executeScript(tabId, {file: "content.js"},
            function(r) {
                if (tabData[tabId].enabled) {
                    updateIcon(tabId, true, true);
                } else {
                    updateIcon(tabId, true, false);
                }
            }
        );
    }
);

chrome.tabs.onRemoved.addListener(
    function onTabRemove(tabId, removeInfo) {
        delete tabData[tabId];
    }
);

chrome.pageAction.onClicked.addListener(
    function onActionClick(tab) {
        var id = tab.id,
            td = tabData[id];
        if (!td.enabled) {
            td.enabled = true;
            updateIcon(id, true, true);
            window.setTimeout(function() { timerCallback(id); }, nppsync.get('pingInterval')||1e3);
        } else {
            td.enabled = false;
            updateIcon(id, true, false);
        }
    }
);