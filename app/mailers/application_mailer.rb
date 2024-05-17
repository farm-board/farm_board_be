class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  def default_url_options
    super.merge(trailing_slash: true)
  end
end
