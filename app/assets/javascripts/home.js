// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

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

  $("#project_developers_array").select2({
    tags: $("#project_developers_array").data("tags"),
    placeholder: "Select tag",
    allowClear: true,
    minimumInputLength: 1,
    width: '100%'
  });

  $("#project_internal_clients_array").select2({
    tags: $("#project_internal_clients_array").data("tags"),
    placeholder: "Select tag",
    allowClear: true,
    minimumInputLength: 1,
    width: '100%'
  });

  $("#project_instance_installation_ids").select2({
    tags: $("#project_instance_installation_ids").data("tags"),
    placeholder: "Select tag",
    allowClear: true,
    minimumInputLength: 1,
    width: '100%'
  });

  $(".filters").bind("DOMNodeInserted", function(){
    $(this).find(".search_init").addClass("projects_filter");
  });

  $("#installations_table").dataTable({
    "iDisplayLength": 50
  }).columnFilter({
    aoColumns: [
    {
      type: "text",
    },
    {
      type: "text",
    },
    {
      type: "text",
    },
    {
      type: "select",
      values: ["Web", "Database", "Web & Database"]
    },
    {
      type: "select",
      values: ["Staging", "Production"]
    },
    {
      type: "text"
    },
    {
      type: "select",
      values: ["true", "false"]
    },
    null,
    null,
    null
    ]
  });

  $("#deleted_installations_table").dataTable({
    "iDisplayLength": 50
  }).columnFilter({
    aoColumns: [
    {
      type: "text",
    },
    {
      type: "text",
    },
    {
      type: "text",
    },
    {
      type: "select",
      values: ["Web", "Database", "Web & Database"]
    },
    {
      type: "select",
      values: ["Staging", "Production"]
    },
    {
      type: "text"
    },
    null,
    null,
    null,
    null
    ]
  });

  $("#servers_table").dataTable();

  $("#dependencies_table").dataTable();

  $("#projects_table").dataTable({
    "iDisplayLength": 50
  }).columnFilter({
    aoColumns: [
    {
      type: "text",
    },
    null,
    {
      type: "select",
      values: ["Under Development", "Delivered", "Project Development", "Discontinued"]
    },
    {
      type: "text"
    },
    {
      type: "text"
    },
    {
      type: "text"
    },
    null
    ]
  });

  $('#soft_delete_btn').on('click', function(e){
    $('#commentModal').modal("show");
    return false;
  })

  $('.comment_form').submit(function() {

    comment = $('.soft_delete_form textarea').first()
    if(comment.val() == "" ) {
      $('.error-block').show()
      comment.css({ "border": '#FF0000 1px solid'});
      return false;
    }
  })

  $('.soft_delete_form textarea').bind('input propertychange', function() {
    if($(this).val().length) {
      $(this).removeAttr('style')
      $(this).parent().find('.error-block').hide()
    }
  })

});
