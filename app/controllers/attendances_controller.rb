class AttendancesController < ApplicationController
  def index
    @workreports = current_user.workreports
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    @attendance_data = Attendance.all.group_by { |attendance| attendance.date.strftime("%W") }
    # Fetch holiday dates from the Holidays table
    holidays = Holiday.pluck(:holiday_date)

    # Create a hash to store the work reports by date for easier lookup
    workreports_by_date = @workreports.index_by(&:date)

    # Iterate over each date from the beginning of the month until today
    @dates = (@date.at_beginning_of_month..@date).to_a
    @attendance_data = @dates.map do |date|
      if holidays.include?(date)
        { date: date, status: "Holiday" } # Show Holiday for holidays
      elsif workreports_by_date[date]
        # Determine the status based on the hours recorded in the work report
        hour_sum = Array(workreports_by_date[date]).sum(&:hours)
        if hour_sum >= 4 && hour_sum <= 7
          { date: date, status: "Half Day" }
        elsif hour_sum < 4
          { date: date, status: "Absent" }
        else
          { date: date, status: "Present" }
        end
      else
        { date: date, status: "Absent" }
      end
    end
  end
end
