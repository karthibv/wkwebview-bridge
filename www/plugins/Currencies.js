navigator.currencies = {
  fetchCurrencyLists: function(onSuccess, onError) {
    Queue.push(Task.init(Queue.length, onSuccess, onError));
    window.webkit.messageHandlers.NativeWebBridge.postMessage({className: 'Currencies', functionName: 'fetchCurrencyLists', taskId: Queue.length - 1});
  }
}


