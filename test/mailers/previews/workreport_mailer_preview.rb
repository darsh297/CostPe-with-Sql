# Preview all emails at http://localhost:3000/rails/mailers/workreport_mailer
class WorkreportMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/workreport_mailer/created
  def created
    WorkreportMailer.created
  end

end
