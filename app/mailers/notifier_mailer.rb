class NotifierMailer < ApplicationMailer
    def new_account(recipient)
        mail(
            to: recipient,
            subject: 'New account information'
        )
    end
end
