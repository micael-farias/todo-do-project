# app/jobs/card_reminder_job.rb
class CardReminderJob < ApplicationJob
  queue_as :default

  def perform
    now = Time.current - 3.hours
    Rails.logger.info "CardReminderJob iniciado em #{now}"

    # Definir os momentos de lembrete
    reminders = {
      2.days => "2 dias",
      1.day => "1 dia",
      6.hours => "6 horas",
      1.hour => "1 hora"
    }

    reminders.each do |time_before_due, label|
      Rails.logger.info "Iniciando processo para lembrete de #{label}"

      due_time = now + time_before_due
      Rails.logger.info "Verificando cards com vencimento entre #{due_time - 1.minute} e #{due_time + 1.minute} (#{label} antes)"

      # Definir uma janela para a verificação (1 minuto antes e depois)
      start_time = due_time - 1.minute
      end_time = due_time + 1.minute

      # Buscar os cards que estão se aproximando da data de vencimento e ainda não foram completados
      cards = Card.joins(board_item: :board)
                  .where(completed: false)
                  .where(due_date: start_time..end_time)
                 # .where("reminders_sent @> ARRAY[?]::integer[] OR reminders_sent IS NULL", label.to_i)

      Rails.logger.info "Encontrados #{cards.count} cards para lembrete de #{label}"

      if cards.empty?
        Rails.logger.info "Nenhum card encontrado para o lembrete de #{label}."
      else
        Rails.logger.info "Iniciando envio de lembretes para #{cards.count} cards."
      end

      cards.find_each do |card|
        Rails.logger.info "Enviando lembrete para card ID #{card.id} - '#{card.title}' com prazo em #{card.due_date}"

        # Simular envio de e-mail
        CardMailer.reminder_email(card, label).deliver_later

        # Atualizar os lembretes enviados para evitar envios duplicados
        updated_reminders = (card.reminders_sent || []) + [label.to_i]
        card.update(reminders_sent: updated_reminders)

        Rails.logger.info "Atualizado 'reminders_sent' para card ID #{card.id}: #{card.reminders_sent}"
      end

      Rails.logger.info "Processo de lembrete para #{label} concluído."
    end

    Rails.logger.info "CardReminderJob concluído em #{Time.current}"
  end
end

