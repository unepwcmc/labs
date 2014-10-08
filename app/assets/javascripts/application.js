// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require select2
//

$(document).ready(function(){
  $(".project").hover(function(event){
    $(this).find('a').css('text-decoration', 'underline');
    $(this).find('img').css('border', '2px solid #33B5E5');
  }, function(event){
    $(this).find('a').css('text-decoration', 'none');
    $(this).find('img').css('border', 'none');
  });

  $(".tag-field").select2({tags:[]}, {
  	placeholder: "Select tag",
    allowClear: true,
    minimumInputLength: 1,
    width: '100%'
  });
});
