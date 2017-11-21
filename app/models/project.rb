class Project < ActiveRecord::Base
  has_many :tasks, dependent: :destroy

  def term
    self.start_date.bussiness_dates(dailies)
  end

  def dailies
    tasks.map(&:dailies).flatten.map(&:the_date).uniq.size
  end
end
