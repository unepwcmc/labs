$(document).ready(function(){
  $("#dependencies_table").dataTable({
    "iDisplayLength": 25,
    "aoColumnDefs" : [{
      "bSortable": false,
      "aTargets": ["no-sort"]
    }]
  });
});
