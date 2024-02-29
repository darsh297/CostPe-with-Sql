class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @chart_labels = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    @chart_data = fetch_working_hours(current_user)

    respond_to do |format|
      format.html
      format.json { render json: { labels: @chart_labels, data: @chart_data } }
    end
  end

  private

  def fetch_working_hours(user)
    working_hours = [0, 0, 0, 0, 0, 0, 0]

    workreports = user.workreports.where("created_at >= ?", 1.week.ago.beginning_of_day)

    workreports.each do |workreport|
      day_of_week = workreport.created_at.strftime("%A") # Assuming you want to use the creation date of the report
      index = @chart_labels.index(day_of_week)

      # Check if the day_of_week is valid and index is found
      if index && index >= 0 && index < working_hours.length
        working_hours[index] += workreport.hours
      end
    end

    working_hours
  end
end

