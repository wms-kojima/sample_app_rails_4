class Date
  def bussiness_dates(count)
    arr = [self.bussiness_date? ? self : self.next_bussiness_date]
    arr << arr.last.next_bussiness_date until arr.size == count
    arr
  end

  def next_bussiness_date
    d = self.next
    d = d.next until d.bussiness_date?
    d
  end

  def bussiness_date?
    self.workday? && !self.holiday?
  end

  def holiday?
    HolidayJp.holiday?(self)
  end

  def youbi
    %w(日 月 火 水 木 金 土)[self.wday]
  end
end