var currencyAPIs={

getCurrencyLists : function(jsCallback){
    console.log("getCurrencyLists call Native ");
    var newPromiseId = generateUUID();
    
    var nativeData = {
        guid: newPromiseId,
        message : "getCurrencyList"
    };
    
    window.webkit.messageHandlers.nativeProcess.postMessage(nativeData);
    callbacksPromises[newPromiseId] = jsCallback;

},
onCurrencyList: function(data) {
    console.log("onCurrencyList currency list ");
    document.getElementById("rawData").innerHTML = data;
    var currencyData = JSON.parse(data);
    if (currencyData) {
       document.getElementById("rawData").innerHTML = currencyData;
    }

}
    
}

// generates a unique id, not obligator a UUID
 function generateUUID() {
    var d = new Date().getTime();
    var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = (d + Math.random() * 16) % 16 | 0;
    d = Math.floor(d / 16);
    return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
    });
    return uuid;
}


function fetchCurrencyList() {
    console.log("fetchcurrentcy");
    currencyAPIs.getCurrencyLists(currencyAPIs.onCurrencyList);
}


var callbacksPromises = {};

    
function executeCallback(guid, data) {
    var theFunction = callbacksPromises[guid];
    if (theFunction) {
        theFunction.call(null, data);
    }
    
    delete callbacksPromises[guid];
}
    


