$ ->
  $("#project_table").tablefix {
    width: 1140
    height: 350
    fixRows: 1
  }

  $(".planed_time_field").on "change", ->
    task_id = $($($(this)).parent().parent()[0]).attr("data-task-id")
    $.ajax document.URL + "/tasks/#{task_id}",
      type: "PATCH",
      dataType: "script",
      data: {
        task: {
          planed_time: $(this)[0].value
        }
      }
    return

  $(".sortable").sortable update: (event, ui) ->
    $.ajax document.URL + "/tasks/sort",
      type: "POST",
      dataType: "script",
      data: {
        id: $(ui.item[0]).attr("data-task-id")
        order: ui.item[0].sectionRowIndex
      }
    return

  $(".sortable").disableSelection();