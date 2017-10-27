var exec = require('cordova/exec');

var GetAjaxRequest = function() {
};

GetAjaxRequest.get = function(url,callback) {
    exec(callback,null, "GetAjaxRequest", "get", [url]);
};

GetAjaxRequest.setCookie = function(cookie,domain,callback) {
    exec(callback,null, "GetAjaxRequest", "setCookie", [cookie,domain]);
};
GetAjaxRequest.clearCookie = function() {
    exec(null,null, "GetAjaxRequest", "clearCookie", []);
};

module.exports = GetAjaxRequest;
