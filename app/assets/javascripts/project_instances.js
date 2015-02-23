$(document).ready(function(){

  $.each($('.closing'), function() {
      if($(this).text() == 'false')
        $(this).addClass('isClosing');
      else
        $(this).addClass('isOpen');
  });

  $("#project_instances_table").dataTable({
    "iDisplayLength": 50
  }).columnFilter({
    aoColumns: [
    {
      type: "text"
    },
    {
      type: "text"
    },
    null,
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
    null,
    null
    ]
  });

  $("#deleted_project_instances_table").dataTable({
    "iDisplayLength": 50
  }).columnFilter({
    aoColumns: [
    {
      type: "text"
    },
    {
      type: "text"
    },
    null,
    {
      type: "select",
      values: ["Staging", "Production"]
    },
    {
      type: "text"
    },
    null,
    null,
    null
    ]
  });
})