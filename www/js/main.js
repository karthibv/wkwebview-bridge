$(document).ready( function(){
  if (console) {
    console.log('Console plugin ready!');
    if (navigator.currencies) {
      console.log('currencies plugin ready!');
    }
  }
});
function currenciesOnSuccess(currList) {
    console.log('currList X: ' + currList.response );
};
function currenciesOnError(e) {
    console.log(e);
};
