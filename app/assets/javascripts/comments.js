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
	  success: function(response) {
	    var image_tag = "<img class= \"gravatar-round\" src=\"http://gravatar.com/avatar/"+
		response.gravatar_id+".png?s=60\">";

		var to_append = "<article class=\"comment\"><a class=\"comment-img\" href=\"#non\">"+
		image_tag+"</a><div class=\"comment-body\"><div class=\"text\"><p>"+response.content+
		"</p></div><p class=\"attribution\"><span>by </span><span class=\"comment-user\">"+response.github+
		"</span><span> at " + response.created_at + "</span>"+
		" <a class=\"comment-delete\" data-confirm=\"Are you sure you want to delete this comment?\" data-method=\"delete\""+
		"href=\"/comments/"+response.comment_id+"\" rel=\"nofollow\">Delete</a></p></div></article>";
		$(".comments").append(to_append);
	  },
	  error: function(response) {
	    alert(response.responseText);
	  }
	});
	return false;
  });

  $(".comments").on('click', '.comment-delete', function(){
    var element = this;
	if(confirm("Are you sure you want to delete this comment?")){
	  $.ajax({
	    type: 'POST',
	    url: $(this).attr('href'),
	    datatype: "JSON",
	    data: {"_method": "delete"},
	    success: function(response) {
	      $(element).closest(".comment").remove();
        },
	    error: function(response) {
	      alert(response.responseText);
	    }
      });
    }
    return false;
  });
});