$(document).ready(function(){

  $('.models-list').on('click', 'li', function(event){
    event.preventDefault();
    var project = $('.project-header').data('project-title');
    var model = $(this).html().toLowerCase();
    loadImageInfo(project, model);
  });

  function loadTextInfo() {
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
  }

  function loadImageInfo(project, model) {
    data = "<img src='/domains/"+project+"/"+model+".png'></img>"
    $('.data-container').html(data)
  }
});
