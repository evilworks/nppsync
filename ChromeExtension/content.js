// This file is part of NppSync plugin by evilworks.
// Licence: Public Domain.

function getLocalLinks(h) {
  var r = [];
  for (i=0; i<h.length;i++) {
    if (h[i].href) {
      if (h[i].href.indexOf('file:///') > -1) {
        r[r.length] = h[i].href.split('///')[1];
      }
    }
    if (h[i].src) {
      if (h[i].src.indexOf('file:///') > -1) {
        r[r.length] = h[i].src.split('///')[1];
      }
    }
  }
  return r
}

function messageListener(message, sender, sendResponse) {
  if (message == 'getResources') { 
    sendResponse(getLocalLinks(document.styleSheets).concat(getLocalLinks(document.scripts)));
  };
  return true;
};

chrome.extension.onMessage.addListener(messageListener);
