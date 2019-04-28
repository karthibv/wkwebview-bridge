//console = {
//  log: function (string) {
//    window.webkit.messageHandlers.NativeWebBridge.postMessage({className: 'Console', functionName: 'log', data: string});
//
//  }
//}
//


var console = {
log: function(message) { //console.log(msg);
    window.webkit.messageHandlers.NativeWebBridge.postMessage({className: "Console", functionName: "log", data: {msg: message}});
}
};
