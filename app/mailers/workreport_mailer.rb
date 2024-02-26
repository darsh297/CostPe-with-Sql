class WorkreportMailer < ApplicationMailer
  def created
    @workreport = params[:workreport]
    @to_emails = params[:to_emails]
    @cc_emails = params[:cc_emails]
    mail(to: @to_emails, cc: @cc_emails, subject: "New Work Report Created")
  end
end
