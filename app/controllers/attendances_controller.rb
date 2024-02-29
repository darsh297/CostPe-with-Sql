class AttendancesController < ApplicationController
    before_action :authenticate_user!

  def index
    @workreports = current_user.workreports
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    @attendance_data = Attendance.all.group_by { |attendance| attendance.date.strftime("%W") }
    holidays = Holiday.pluck(:holiday_date)

    workreports_by_date = @workreports.index_by(&:date)

    @dates = (@date.at_beginning_of_month..@date).to_a
    @attendance_data = @dates.map do |date|
      if holidays.include?(date)
        { date: date, status: "Holiday" }
      elsif workreports_by_date[date]
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
