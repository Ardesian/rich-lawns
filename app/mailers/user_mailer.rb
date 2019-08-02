class UserMailer < ApplicationMailer
  def invoice(recipient)
    @title = "Thank you for using our services!"
    mail(
      to: recipient,
      from: "billing@rich-lawns.com",
      subject: "Thank you for using our services!"
    )
  end

  def email(opts)
    @title = opts[:subject]
    @body = opts[:body]

    mail(
      to:           opts[:to],
      from:         opts[:from] || "admin@rich-lawns.com",
      subject:      opts[:subject],
      content_type: opts[:content_type] || "text/html",
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
