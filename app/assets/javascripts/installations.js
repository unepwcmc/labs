$(document).ready(function(){

  $("#installations_table").dataTable({
    "iDisplayLength": 25
  }).columnFilter({
    aoColumns: [
    {
      type: "text",
    },
    {
      type: "text",
    },
    {
      type: "select",
      values: gon.roles
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
})
