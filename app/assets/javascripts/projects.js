// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  function showAlt(){
    $(this).closest('a').attr("href", "#non");
    $(this).replaceWith(this.alt);
  }

  function addURLPresenceValidation(){
    const publishedCheckbox = $("#project_published");
    const urlInput = $("#project_url")

    urlInput.attr("required", publishedCheckbox.is(":checked"));

    publishedCheckbox.change(function() { 
      urlInput.attr("required", this.checked);
    });
  }

  addURLPresenceValidation();

  $(".badge_img").error(showAlt);

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

  $("#project_designers_array").select2({
    tags: $("#project_designers_array").data("tags"),
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
    "iDisplayLength": 25,
    "aoColumnDefs" : [{
      "bSortable": false,
      "aTargets": ["no-sort"]
    }]
  }).columnFilter({
    sPlaceHolder: "head:before",
    aoColumns: [
    {
      type: "text",
    },
    {
      type: "select",
      values: gon.states
    },null, null,
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