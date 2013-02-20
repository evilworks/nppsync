// This file is part of NppSync plugin by evilworks.
// Licence: Public Domain.

var defaultSettings = {
  serverPort: 40500
};

function saveSettings() {
  // Save values.
  localStorage["serverPort"] = document.getElementById("serverPort").value;

  // Update status to let user know options were saved.
  var status = document.getElementById("status");
  status.innerHTML = "Options Saved.";
  setTimeout(function() {
    status.innerHTML = "";
  }, 1000);
};

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
document.querySelector('#save').addEventListener('click', saveSettings);