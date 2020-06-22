class ReservationMailer < ApplicationMailer
    def send_email_to_customer(customer, service)
    
      @recipient = customer
      @service = service
      mail(to: @recipient.email, subject: "Enjoy You Service! 😘 💋")
    end
  end