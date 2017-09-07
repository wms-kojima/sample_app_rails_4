$ ->
  $("#project_table").tablefix {
    width: 1100
    height: 350
    fixRows: 1
    # fixCols: 4
  }

  $(".planed_time_field").on "change", ->
    alert("puti")

  $(".sortable").sortable();
  $(".sortable").disableSelection();