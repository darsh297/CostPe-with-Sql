module AttendancesHelper
  # Define color_for_status method
def color_for_status(status)
  case status
  when 'Present'
    'green'
  when 'Absent'
    'red'
  when 'Holiday'
    'blue'
  when 'Half Day'
    'yellow'
  else
    'black' # Default color
  end
end

end
