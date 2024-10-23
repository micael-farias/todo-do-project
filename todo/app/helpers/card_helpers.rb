# app/helpers/cards_helper.rb
module CardsHelper
  
    def priority_title(priority)
      case priority
      when 3
        'Prioridade Alta'
      when 2
        'Prioridade Média'
      when 1
        'Prioridade Baixa'
      else
        'Sem Prioridade'
      end
    end
  end
  