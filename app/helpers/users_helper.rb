module UsersHelper
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end
  
  def format_hour(time)
    format("%.d", ((time.hour)))
  end
  
  def format_min(time)
    format("%.2d", (((time.min).floor/15)*15))
    #format("%.2d", (((time.min)/15)*15))
  end
end