// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })

  function showAlt(){
    $(this).closest('a').attr("href", "#non")
    $(this).replaceWith(this.alt)
  };

  $(".badge_img").error(showAlt)

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

  $("#projects_table").dataTable({
    "iDisplayLength": 25
  }).columnFilter({
    sPlaceHolder: "head:before",
    aoColumns: [
    {
      type: "text",
    },
    {
      type: "select",
      values: gon.states
    },null,
    {
      type: "select",
      values: gon.rails_versions
    },
    {
      type: "select",
      values: gon.ruby_versions
    },
    {
      type: "select",
      values: gon.postgresql_versions
    },
    null
    ]
  });

});