module StaticPagesHelper
  def acition_name(task)
    if task.status == "not_started"
      "start"
    else
      "finish"
    end
  end

  def status_name(status)
    case status
    when "not_started"
      "未着手"
    when "working"
      "着手中"
    when "done"
      "完了"
    else
      status
    end
  end
end
