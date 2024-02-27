class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch working hours data from Workreport model
    @chart_labels = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    # Fetch working hours data for the current user from last Monday until today
    @chart_data = fetch_working_hours(current_user)

    respond_to do |format|
      format.html
      format.json { render json: { labels: @chart_labels, data: @chart_data } }
    end
  end

  private

  def fetch_working_hours(user)
    # Initialize an array to store working hours for each day of the week
    working_hours = [0, 0, 0, 0, 0, 0, 0]

    # Fetch workreports for the current user from last Monday until today
    workreports = user.workreports.where("created_at >= ?", 1.week.ago.beginning_of_day)

    # Loop through each workreport and calculate working hours for each day of the week
    workreports.each do |workreport|
      day_of_week = workreport.created_at.strftime("%A") # Assuming you want to use the creation date of the report
      index = @chart_labels.index(day_of_week)
      next unless index # Skip if the day of the week is not found in the labels

      # Add the total hours from the workreport to the corresponding index in the working_hours array
      working_hours[index] += workreport.hours
    end

    # Return the array of working hours for each day of the week
    working_hours
  end
end
