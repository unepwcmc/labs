// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

  $(".filters").bind("DOMNodeInserted", function(){
    $(this).find(".search_init").addClass("products_filter");
  });

  $('.comment_btn').on('click', function(e){
    $('#commentModal').modal("show");
    return false;
  })

  $('.comment_form').submit(function() {
    comment = $('.soft_delete_form textarea').first();
    if(comment.val() == "" ) {
      $('.error-block').show();
      comment.css({ "border": '#FF0000 1px solid'});
      return false;
    }
  });

  $('.soft_delete_form textarea').bind('input propertychange', function() {
    if($(this).val().length) {
      $(this).removeAttr('style');
      $(this).parent().find('.error-block').hide();
    }
  });

  $('a[title]').tooltip();

});
