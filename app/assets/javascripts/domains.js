$(document).ready(function(){

  $('.models-list').on('click', 'li', function(event){
    event.preventDefault();
    var project = $('.project-header').data('project-title');
    var model = $(this).html().toLowerCase();
    loadImageInfo(project, model);
  });

  function loadImageInfo(project, model) {
    data = "<img src='/domains/"+project+"/"+model+".png'></img>"
    $('.data-container').html(data)
  }
});
