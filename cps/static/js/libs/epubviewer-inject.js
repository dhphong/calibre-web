function _isRavenDisabled() {
    try {
        if (typeof disableRaven !== 'undefined' && disableRaven) return true;
        return false;
    } catch (ex) {
        return false;
    }
}

if (!_isRavenDisabled() && (window.location.toString().indexOf("ePubViewer-gh-pages") > -1 || window.location.toString().indexOf("Users") > -1)) {
    window.disableRaven = true;
    console.log("If you are planning to make changes to your own copy of ePubViewer, it would be nice if you could remove the Sentry error reporting (all the Raven stuff). Thanks!");
}

// if (window.location.toString().indexOf(atob("ZWxpbmhhcmVz") > -1)) {
//     document.title = "license-violating reader";
//     window.location = "https://pgaskin.net/ePubViewer";
// }
