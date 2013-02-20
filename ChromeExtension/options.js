// This file is part of NppSync plugin by evilworks.
// Licence: Public Domain.

var defaultSettings = {
  serverPort: 40500
};

function showStatus(s) {
  var status = document.getElementById("status");
  status.innerHTML = s;
  setTimeout(function() {
    status.innerHTML = "";
  }, 1000);
}

function saveSettings() {
  // Save values.
  localStorage["serverPort"] = document.getElementById("serverPort").value;

  showStatus("Settings saved.")
};

function restoreDefaults() {

  showStatus("Defaults restored.")
}

function readSetting(name, ctrlId) {
  var val = localStorage[name];
  if (val === undefined) {
    val = defaultSettings[name];
    localStorage[name] = val;
  }
  document.getElementById(ctrlId).value = val;
}

function readSettings() {
  readSetting("serverPort", "serverPort");
};

document.addEventListener('DOMContentLoaded', readSettings);
document.querySelector('#restoreDefaults').addEventListener('click', restoreDefaults);
document.querySelector('#saveSettings').addEventListener('click', saveSettings);
