$(document).ready(function(){

  $('.models-list').on('click', 'li', function(event){
    event.preventDefault();
    var domain_id = $('.domain-container').data('domain-id');
    var model_id = $(this).data('model-id');
    $.ajax({
      url: domain_id+"/select_model?model_id="+model_id,
      error: function(jqXHR, textStatus, errorThrown) {
        console.log("AJAX Error:" + textStatus);
      },
      success: function(data, textStatus, jqXHR) {
        $('.data-container').html(data);
      }
    });
  });
});
