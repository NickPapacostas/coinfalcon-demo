function addEventListeners() {
  const createButton = document.querySelector('#create-batch-submit')
  createButton.addEventListener('click', function(event) {
    createButton.style.display = 'none'
    document.querySelector('#create-batch-spinner').style.display = 'initial'
  })
}

document.onreadystatechange = function () {
  if (document.readyState === "complete") {
    addEventListeners();
  }
}