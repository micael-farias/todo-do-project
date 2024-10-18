class CardMailer < ApplicationMailer
    default from: 'quixalert@gmail.com'
  
    def reminder_email(card, time_before_due)     
      @card = card
      @time_before_due = time_before_due
      mail(to: "filmesde2022@gmail.com", subject: "Lembrete: Sua tarefa '#{@card.title}' está para vencer")
    end
  end
  