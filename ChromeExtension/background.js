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

function pollResource(tabId, n) {
	var r = new XMLHttpRequest();
	r.open("GET", "http://localhost:40500/" + encodeURIComponent(n), true);
	r.onreadystatechange = function () {
		if (r.readyState == 4) {
			chrome.tabs.get(tabId,
				function (tab) {
				if (tab !== undefined) {
					tabData[tabId].checkCount++;
					if (r.responseText != tabData[tabId].files[n].hash) {
						tabData[tabId].files[n].hash = r.responseText;
						tabData[tabId].needsReload = true;
					};
					if (tabData[tabId].checkCount == tabData[tabId].filesCount) {
						if (tabData[tabId].needsReload) {
							chrome.tabs.reload(tabId, {
								bypassCache : true
							});
						};
						tabData[tabId].checkCount = 0;
						tabData[tabId].needsReload = false;
						if (tabData[tabId].enabled) {
							window.setTimeout(function () {
								timerCallback(tabId)
							}, 1000);
						};
					};
				};
			});
		};
	};
	try {
		r.send();
	} catch (err) {
		console.log(err);
	}
};

function timerCallback(tabId) {
	chrome.tabs.get(tabId, function (tab) {
		if (tab === undefined) {
			return;
		}

		chrome.tabs.sendMessage(tabId, "getResources",
			function (response) {
			tabData[tabId].checkCount = 0;
			tabData[tabId].needsReload = false;
			tabData[tabId].filesCount = 0;
			var htmlPage = tab.url.split('///')[1];
			for (var prop in tabData[tabId].files) {
				if ((prop != htmlPage) && (response.indexOf(prop) < 0)) {
					delete tabData[tabId].files[prop]
				}
			}
			for (i = 0; i < response.length; i++) {
				if (tabData[tabId].files[response[i]] === undefined) {
					tabData[tabId].files[response[i]] = {
						hash : '0'
					};
				}
			}
			for (prop in tabData[tabId].files) {
				tabData[tabId].filesCount++;
			}
			for (var prop in tabData[tabId].files) {
				pollResource(tabId, prop)
			}
		});
	});
}

chrome.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
	if (changeInfo.status != "complete") {
		return
	}
	if (tab.url.indexOf('file:///') < 0) {
		return
	}
	if (tabData === undefined) {
		updateIcon(false, false)
	}

	chrome.tabs.executeScript(tabId, {
		file : "content.js"
	}, function (r) {
		if (tabData[tabId] === undefined) {
			tabData[tabId] = {
				enabled : false,
				checkCount : 0,
				filesCount : 0,
				needsReload : false,
				files : {}
			}
			tabData[tabId].files[tab.url.split('///')[1]] = {
				hash : '0'
			};
			tabData[tabId].filesCount = 1;
		}
		if (tabData[tabId].enabled) {
			updateIcon(tabId, true, true);
		} else {
			updateIcon(tabId, true, false);
		}
	});
});

chrome.tabs.onRemoved.addListener(function (tabId, removeInfo) {
	delete tabData[tabId];
});

chrome.pageAction.onClicked.addListener(function (tab) {
	if (!tabData[tab.id].enabled) {
		tabData[tab.id].enabled = true;
		updateIcon(tab.id, true, true);
		window.setTimeout(function () {
			timerCallback(tab.id)
		}, 1000);
	} else {
		tabData[tab.id].enabled = false;
		updateIcon(tab.id, true, false);
	}
});
