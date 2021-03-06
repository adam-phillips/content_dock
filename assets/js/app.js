// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import { Socket } from "phoenix"
import NProgress from "nprogress"
import { LiveSocket } from "phoenix_live_view"
import Quill from "quill"
import "quill/dist/quill.snow.css"

function initQuill() {
  const editorInstance = new Quill('#editor', {
    debug: 'info',
    theme: 'snow'
  });
  editorInstance.enable();
  editorInstance.on('text-change', function (delta, oldDelta, source) {
    document.querySelector('#blog-form_blog_content').value = JSON.stringify(editorInstance.getContents());
    document.querySelector('#blog-form_rendered_html').value = document.querySelector('#editor').children[0].innerHTML;
    console.log('getContents', JSON.stringify(editorInstance.getContents()));
    console.log('innerHTML', document.querySelector('#editor').children[0].innerHTML);
  });
  // TODO: when editing blog, decode JSON from `blog_content` and put in Quill
}

let Hooks = {};
Hooks.LoginToken = {
  mounted() {
    console.log("Mounted")
    this.handleEvent("login_token_validated", ({ token, redirect }) => {
      console.log("Event received")
      var xmlHttpRequest = new XMLHttpRequest();
      xmlHttpRequest.open("GET", "/session/set_session/" + token, false);
      xmlHttpRequest.send(null);
      if (xmlHttpRequest.responseText == "ok") {
        window.location = redirect;
      }
      else {
        alert("Failure");
      }
    })
  }
}

Hooks.QuillEditor = {
  mounted() {
    if (document.readyState == "complete") {
      initQuill();
    } else {
      document.addEventListener("readystatechange", () => {
        if (document.readyState == "complete") {
          initQuill();
        }
      })
    }
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks })

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

