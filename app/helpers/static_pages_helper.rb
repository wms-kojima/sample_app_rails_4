module StaticPagesHelper
  def acition_name(task)
    if task.status == "not_started"
      "start"
    else
      "finish"
    end
  end
end
