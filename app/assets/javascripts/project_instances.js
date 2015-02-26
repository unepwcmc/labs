$(document).ready(function(){

  $.each($('.closing'), function() {
      if($(this).text() == 'false')
        $(this).addClass('isClosing');
      else
        $(this).addClass('isOpen');
  });

  $("#project_instances_table").dataTable({
    "iDisplayLength": 25
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
      values: gon.stages
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
})