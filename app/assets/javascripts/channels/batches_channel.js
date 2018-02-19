$(document).on('turbolinks:load', function() {
  if (App.batches) {
    return App.batches;
  }
})

App.batches = App.cable.subscriptions.create('BatchesChannel', {
  received: function(data) {
    console.log("RECEIVED UPDATE")
    console.log(data)
    return data;
    // batch_update
    // return $("[data-a-batch='" + data.batch_id + "']'").innerhtml
  }

  // collection: function() {
  //   return $('.project-box');
  // },
  // connected: function(){
  //   return setTimeout((function(_this){
  //         return function() {
  //           return _this.followBatches();
  //         };
  //       })(this), 1000);
  // },
  // followBatches: function() {

  // }
});