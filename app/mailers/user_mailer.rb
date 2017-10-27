class UserMailer< ApplicationMailer

  def apply_job_email(params)
    @mail_info = params
    mail(to: params[:email], bcc: ['haulv@zigexn.vn'], subject: 'Thank you for apply with VeNJOB', layout: 'apply_job_email')
  end
end
