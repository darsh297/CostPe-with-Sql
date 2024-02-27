namespace :workreports do
  desc "Find users with pending reports"
  task find_pending_reports: :environment do
    WorkreportsController.users_with_pending_reports
  end
end
