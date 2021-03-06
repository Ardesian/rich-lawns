# Preview all emails at http://localhost:7424/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:7424/rails/mailers/user_mailer/email
  def email
    UserMailer.email(
      to: "test@email.com",
      subject: "Test Subject",
      body: "This is the test body"
    )
  end

  def invoice
    UserMailer.invoice(Invoice.last)
  end

end
