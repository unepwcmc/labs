$(document).ready(function(){

  $.each($('.closing'), function() {
      if($(this).text() == 'false')
        $(this).addClass('isClosing');
      else
        $(this).addClass('isOpen');
  });

  $("#product_instances_table").dataTable({
    "iDisplayLength": 25,
    "aoColumnDefs" : [{
      "bSortable": false,
      "aTargets": ["no-sort"]
    }]
  }).columnFilter({
    sPlaceHolder: "head:before",
    aoColumns: [
    {
      type: "text"
    },
    {
      type: "text"
    },
    {
      type: "select",
      values: gon.stages
    },
    {
      type: "text"
    },
    null,
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

  $('#show_soft-deleted').click(function(){
    $('#soft-deleted_installations').slideToggle();
  });
});
