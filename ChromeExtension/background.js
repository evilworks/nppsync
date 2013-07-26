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
	};
};

var tabData = {};

var tabData = {};

function pollResource(tabId, n) {
    nppsync.request(n, function (response) {
        chrome.tabs.get(tabId, function(tab) {
            if (tab !== undefined) {
                var td = tabData[tabId];
                td.checkCount++;
                if (response != td.files[n].hash) {
                   
                    // log([n, response])
                    // log(td)
                    
                    td.files[n].hash = response;
                    td.needsReload = true;
                };
                if (td.checkCount == td.filesCount) {         
                    if (td.needsReload) {
                        chrome.tabs.reload(tabId, {bypassCache: true});
                    };
                    td.checkCount = 0;
                    td.needsReload = false;
                    if (td.enabled) {
                        window.setTimeout(function() {timerCallback(tabId)}, nppsync.get('pingInterval')||1e3);
                    };
                };
            };
        });    
    }, function (error,x) {
        console.log(error,x);
    });
};

function timerCallback(tabId) {
    chrome.tabs.get(tabId, 
        function(tab) {
            if (tab === undefined) {
                delete tabData[tabId];
                return;
            }
        
            chrome.tabs.sendMessage(tabId, "getResources", 
                function tabMessageRes(response) {
                    var td = tabData[tabId],
                        respath = {};
                        
                    td.filesCount =
                    td.checkCount = 0;
                    td.needsReload = false;
                    
                    nppsync.each(response, function (i, h, f) {
                        f = nppsync.filepath(h);
                        if(f) {
                            respath[f] = h;
                            if( !td.files[f] ) {
                                td.files[f] = {hash: '0'};           
                            }
                        }
                    });
                    
                    nppsync.each(td.files, function (i) {
                        if (i != td.tabfile && i != td.tabroot && !(i in respath)) {
                            delete td.files[i]
                        }
                    });

                    td.filesCount = Object.keys(td.files).length;
                    // log(td.files)
                    nppsync.each(td.files, function (i) {
                        pollResource(tabId, i)
                    });
                }
            );
        }
    );
}

function updateIcon(tabId, show, enabled) {
    if (show) {
        chrome.pageAction.show(tabId);
        if (enabled) {
            chrome.pageAction.setIcon({
                tabId : tabId,
                path  : "icon_19_enabled.png"
            });
            chrome.pageAction.setTitle({
                tabId : tabId,
                title : "NppSync is enabled."
            });
        } else {
            chrome.pageAction.setIcon({
                tabId : tabId,
                path  : "icon_19_disabled.png"
            });
            chrome.pageAction.setTitle({
                tabId : tabId,
                title : "NppSync is disabled."
            });
        }
    } else {
        chrome.pageAction.hide(tabId);
    };
};


chrome.tabs.onUpdated.addListener(
    function onTabUpdated(tabId, changeInfo, tab) {    
        if (changeInfo.status != "complete") { return }
        var tabfile = nppsync.filepath(tab.url);
        if (!tabfile) { return }
        var tabroot = nppsync.rootpath(tab.url);
        if (tabData === undefined) {updateIcon(false, false)}
            
        chrome.tabs.executeScript(tabId, {file: "content.js"}, 
            function(r) {
                var td = tabData[tabId];
                if (td === undefined) {
                    tabData[tabId] = td = {
                        enabled: false,
                        checkCount: 0,
                        filesCount: 0,
                        needsReload: false,
                        tabfile: tabfile,
                        files: {}
                    };
                    if(tabroot) td.tabroot = tabroot;
                    td.files[tabroot || tabfile] = {hash: '0'};
                    td.filesCount = 1;
                }
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
            window.setTimeout(function() {
                timerCallback(id)
            }, nppsync.get('pingInterval')||1e3);
        } else {
            td.enabled = false;
            updateIcon(id, true, false);
        }
    }
);