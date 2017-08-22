class Project < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  def term
    # self.start_date + 18ここいい感じにする
    (self.start_date..self.start_date + 18).select{ |d| (1..5).include?(d.wday) }
  end
end
