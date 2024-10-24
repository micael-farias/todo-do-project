module Cards
  class AssignMoodService
    require 'openai'

    def initialize(card)
      @card = card
      @user = @card.board_item.board.user
    end

    def call
      # Criar o prompt para a API OpenAI
      prompt = build_prompt(@card.title)

      # Fazer a chamada à API OpenAI
      response = fetch_openai_response(prompt)

      if valid_response?(response)
        mood_response = extract_mood_response(response)
        mood = Mood.find_by(name: mood_response)

        process_mood(@card, @user, mood, mood_response)
      else
        log_error("Falha ao obter resposta do OpenAI para o card ID #{@card.id}.")
      end

    rescue => e
      log_error("Erro em AssignMoodService para o card ID #{@card.id}: #{e.message}")
    end

    private

    # Método para construir o prompt do OpenAI
    def build_prompt(title)
      "Dado o título da tarefa: '#{title}', qual seria o humor ideal para realizar essa tarefa? Escolha entre: Excelente, Bom, Neutro, Baixo, Pessimo. Responda apenas com um único humor."
    end

    # Método para fazer a requisição ao OpenAI
    def fetch_openai_response(prompt)
      OPENAI_CLIENT.chat(
        parameters: {
          model: 'gpt-4',
          messages: [
            { role: "system", content: "Você é um assistente útil que categoriza tarefas com base no título." },
            { role: "user", content: prompt }
          ],
          temperature: 0.7
        }
      )
    end

    # Método para verificar se a resposta da API é válida
    def valid_response?(response)
      response && response['choices'] && response['choices'].first['message']
    end

    # Método para extrair o humor da resposta
    def extract_mood_response(response)
      response['choices'].first['message']['content'].strip.capitalize
    end

    # Método para processar o humor e atualizar o card
    def process_mood(card, user, mood, mood_response)
      if mood
        card.update(mood: mood, mood_source: 'ai_suggested')
        user.increment!(:credits_openai_used, 1)
      else
        log_error("Humor '#{mood_response}' não encontrado para o card ID #{card.id}.")
      end
    end

    # Método para logar erros
    def log_error(message)
      Rails.logger.error(message)
    end
  end
end
