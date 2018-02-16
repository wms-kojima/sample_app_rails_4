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

    task_id = $(this).parents(".task_row").attr("data-task-id")
    $.ajax (document.URL + "/tasks/#{task_id}.json"),
      type: "GET",
      dateType: "script",
      data: { task_id: task_id },
      context: this,
      success: (task) ->
        title_label = $("<label>", { text: "件名" })
        title = $("<input>", { type: "text", value: task.name, class: "task_title" })
        content_label = $("<label>", { text: "内容" })
        content = $("<textarea>", { row: 5, text: task.content, class: "task_content" })
        update_button = $("<a>", { class: "btn btn-primary task_update_button pull-right", text: "更新" })
        close_button = $("<input>", { type: "button", class: "close", value: "×" })
        panel_body = $("<div>", { class: "panel-body" }).append(close_button, title_label, title, content_label, content, update_button);
        edit_panel = $("<div>", { class: "panel edit_panel" }).append(panel_body)
        $(this).after(edit_panel)

  $(document).on "click", ".task_update_button", ->
    name = $(this).parent().find(".task_title").val()
    task_update $(this), { name: name, content: $(this).parent().find(".task_content").val() }
    $(this).parents(".edit_panel").prev(".feed_item_title").text(name)
    panel_close($(this))

  $(".planed_time_field").on "change", ->
    task_update $(this), { planed_time: $(this)[0].value }

  $(".task_user_field").on "change", ->
    task_update $(this), { user_id: $(this)[0].value }

  task_update = (element, data) ->
    task_id = element.parents(".task_row").attr("data-task-id")
    $.ajax document.URL + "/tasks/#{task_id}",
      type: "PATCH",
      dataType: "script",
      data: {
        task: data
      }

  $(document).on "click", ".close", ->
    panel_close($(this))

  panel_close = (element) ->
    element.parents(".edit_panel").hide()