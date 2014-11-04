// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

  function showAlt(){
    $(this).closest('a').attr("href", "#non")
    $(this).replaceWith(this.alt)
  };

  $(".badge_img").error(showAlt).attr("src", $(selector).src)

});