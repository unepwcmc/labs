$(document).ready(function(){

  $('.models-list').on('click', 'li', function(event){
    event.preventDefault();
    var product = $('.product-header').data('product-title');
    var model = $(this).html().toLowerCase();
    loadImageInfo(product, model);
  });

  function loadImageInfo(product, model) {
    data = "<img src='/domains/"+product+"/"+model+".png'></img>"
    $('.data-container').html(data)
  }
});
