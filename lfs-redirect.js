(function () {
  var LFS_EXTS = ["zip","webm","mp4","pptx","key","odp","swf","iso","mp3","wmv","odt","pdf","tar","ogg","mov","wav"];
  var SELECTORS = [
    ["a","href"], ["img","src"], ["video","src"], ["audio","src"],
    ["source","src"], ["link","href"], ["iframe","src"]
  ];

  function getExtension(pathname) {
    var match = String(pathname || "").toLowerCase().match(/\.([a-z0-9]+)$/);
    return match ? match[1] : "";
  }

  function isGithubHost(hostname) {
    return /(^|\.)github\.com$/.test(hostname) || /(^|\.)githubusercontent\.com$/.test(hostname);
  }

  function buildGithubUrl(u) {
    var path = u.pathname.replace(/^\//, "") + (u.search || "") + (u.hash || "");
    var ext = getExtension(u.pathname);
    if (ext === "pdf") {
      return "https://media.githubusercontent.com/media/ocftw/creativecommons.tw/gh-pages/" + path;
    }
    return "https://github.com/ocftw/creativecommons.tw/blob/gh-pages/" + path;
  }

  function rewriteElement(el, tag, attr) {
    var val = el.getAttribute(attr);
    if (!val) return;

    var u;
    try {
      u = new URL(val, location.href);
    } catch (e) {
      return;
    }

    if (u.origin !== location.origin.replace("web-archive-2025.", "")) return;

    var ext = getExtension(u.pathname);
    if (LFS_EXTS.indexOf(ext) === -1) return;

    if (isGithubHost(u.hostname)) return;

    var gh = buildGithubUrl(u);
    el.setAttribute(attr, gh);

    if (tag === "a" && ext !== "pdf") {
      el.setAttribute("target", "_blank");
      el.setAttribute("rel", "noopener");
    }
  }

  function run() {
    for (var i = 0; i < SELECTORS.length; i++) {
      var pair = SELECTORS[i];
      var tag = pair[0];
      var attr = pair[1];
      var nodes = document.querySelectorAll(tag + "[" + attr + "]");
      for (var j = 0; j < nodes.length; j++) {
        rewriteElement(nodes[j], tag, attr);
      }
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", run);
  } else {
    run();
  }
})();
