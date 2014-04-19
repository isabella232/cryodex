// Server URL setup
SERVER_URL = window.location.origin;
window.URL = window.URL || window.webkitURL;

// Webkit polyfill for Blob.slice()
Blob.prototype.slice = Blob.prototype.slice ||
                       Blob.prototype.webkitSlice;

window.ESHQ_ORIGIN = 'https://app.eventsourcehq.com';

// Global namespacing
Syme = {
  Collections: {},
  Models: {},
  Views: {}
};