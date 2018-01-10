$ ->
  $("#project_table").tablefix {
    width: 1140
    height: 350
    fixRows: 1
  }

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

  $(".feed_item_title").on "click", ->
    $(".edit_panel").remove()
    $(this).after("<div class=\"panel edit_panel\"><div class=\"panel-body\">#{ $(this).text() }<br>#{ $(this).parent().find(".feed_item_content").val() }</div></div>")

  $(".planed_time_field").on "change", ->
    task_update $(this), { planed_time: $(this)[0].value }

  $(".task_user_field").on "change", ->
    task_update $(this), { user_id: $(this)[0].value }

  task_update = (element, date) ->
    task_id = $(element.parent().parent()).attr("data-task-id")
    $.ajax document.URL + "/tasks/#{task_id}",
      type: "PATCH",
      dataType: "script",
      data: {
        task: date
      }
