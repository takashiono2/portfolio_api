module AttendancesHelper

  def change_y(day)#dayは繰り返しの時のインスタンス、年の抜き出し
    day.worked_on.try(:strftime,"%Y").to_i 
  end
  
  def change_m(day)#dayは繰り返しの時のインスタンス、月の抜き出し
    day.worked_on.try(:strftime,"%m").to_i 
  end
  
  def change_d(day)#dayは繰り返しの時のインスタンス,日の抜き出し
    day.worked_on.try(:strftime,"%d").to_i 
  end

end
