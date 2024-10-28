module CardHelper
    def highlight_background_color(card, highlight_id)
      (highlight_id.present? && card.id.to_s == highlight_id) ? 'var(--card-highlighted)' : 'var(--card)'
    end
  
    def priority_circle_color(priority)
      case priority
      when 1 then 'rgb(4, 51, 77)'
      when 2 then 'rgb(56, 122, 158)'
      when 3 then 'rgb(131, 198, 235)'
      else '#6f6f6f'
      end
    end
  
    def priority_text(priority, prefix: nil)
      text = case priority
             when 3 then 'Alta'
             when 2 then 'Média'
             when 1 then 'Baixa'
             else 'Sem Prioridade'
             end
      
      prefix ? "#{prefix} #{text}" : text
    end
  
    def mood_display_text(card)
      return 'Não definido' unless card.mood&.name
  
      text = card.mood.name
      text += ' (sugerido por IA)' if card.mood_source == 'ai_suggested'
      text
    end

    def format_due_info(date)
      if date.present?
        date.strftime("%d/%m/%Y")
      else
        "Sem data definida"
      end
    end
end