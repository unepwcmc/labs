// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

	$("form#new_comment").submit(function(){
	  var text = $("textarea#comment_content").val();
	  var valuesToSubmit = $(this).serialize();
	  $.ajax({
		  type: 'POST',
		  url: $(this).attr('action'),
		  data: valuesToSubmit,
		  dataType: "JSON",
	  }).success(function(response) {
		  var image_tag = "<img class= \"gravatar-round\" src=\"http://gravatar.com/avatar/"+
		  response.gravatar_id+".png?s=60\">";

		  var to_append = "<article class=\"comment\"><a class=\"comment-img\" href=\"#non\">"+
		  image_tag+"</a><div class=\"comment-body\"><div class=\"text\"><p>"+response.content+
		  "</p></div><p class=\"attribution\"> by <span class=\"comment-user\">"+response.github+
		  "</span> at " + response.created_at + "</p></div></article>";

		  $(".comments").append(to_append);
	  });
	  return false;
	});

});
