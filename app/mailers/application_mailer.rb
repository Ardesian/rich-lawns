class ApplicationMailer < ActionMailer::Base
  default from: 'admin@rich-lawns.com'
  layout 'mailer'

  def email(opts)
    mail(
      to:           opts[:to],
      from:         opts[:from] || "admin@rich-lawns.com",
      subject:      opts[:subject],
      content_type: opts[:content_type] || "text/html",
      body:         opts[:body]
    )
  end

  def deliver_email(email_id)
    email = Email.find(email_id).to_mail
    mail(
      to: email.to,
      from: email.from,
      subject: email.subject,
      content_type: "text/html",
      body: email.body.raw_source
    )
  end
end
