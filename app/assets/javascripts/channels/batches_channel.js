$(document).on('turbolinks:load', function() {
  if (App.batches) {
    return App.batches;
  }
})

App.batches = App.cable.subscriptions.create('BatchesChannel', {
  updateBalanced: function(data) {
    const batchId = data['data']['batch_id']
    const newIds = data['data']['new_order_ids']
    const newPrice = data['data']['new_price']

    const batch = document.querySelector(`[data-a-batch="${batchId}"]`)

    const batchOrders = document.querySelector(`[data-a-batch="${batchId}"] .orders`)
    const newOrders = document.createElement('td')
    newOrders.textContent = newIds.join(", ")
    newOrders.style['overflow-x'] ='scroll';
    $(batchOrders).replaceWith(newOrders);

    
    const newCurrentPrice = document.createElement('td')
    const oldPriceEl = document.querySelector(`[data-a-batch="${batchId}"] .current-price`)
    newCurrentPrice.textContent = newPrice
    oldPriceEl.replaceWith(newCurrentPrice)

    batch.classList.add('updated')
    setTimeout(function(){ batch.classList.remove('updated')}, 2000)
  },

  received: function(data) {
    switch(data['message']) {
      case 'balanced':
        this.updateBalanced(data)
        break;
      default:
        break;
    }
    return data;
  }
});