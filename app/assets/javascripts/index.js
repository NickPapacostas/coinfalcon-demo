function addEventListeners() {
  const createButton = document.querySelector('#create-batch-submit')
  createButton.addEventListener('click', function(event) {
    createButton.style.display = 'none'
    document.querySelector('#create-batch-spinner').style.display = 'initial'
  })

  const marketSelect = document.querySelector('#batch_market')
  marketSelect.addEventListener('change', function(event) {
    const newMarket = event.target.value
    const newPrice = document.querySelector(`#${newMarket}`).getAttribute('data-price')
    const marketPriceEl = document.querySelector('#batch-form-market-price')
    const orderPriceEl = document.querySelector('#batch-form-order-price')

    marketPriceEl.innerText = `current price: ${newPrice}`
    marketPriceEl.setAttribute('data-price', newPrice)
  })
}

document.onreadystatechange = function () {
  if (document.readyState === "complete") {
    addEventListeners();
  }
}