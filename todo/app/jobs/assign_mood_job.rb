# app/jobs/assign_mood_job.rb

class AssignMoodJob < ApplicationJob
    queue_as :default
  
    require 'openai'
  
    def perform(card_id)
      card = Card.find(card_id)
      title = card.title
  
      client = OpenAI::Client.new(
        access_token: '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'     # ID da sua organização
        )
  
      # Construir o prompt para o ChatGPT
      prompt = "Dado o título da tarefa: '#{title}', qual seria o humor ideal para realizar essa tarefa? Escolha entre: Excelente, Bom, Neutro, Baixo, Pessimo. Responda apenas com um único humor."
            Rails.logger.error "Humor '#{client}' não encontrado para o card ID #{card_id}."


      response = client.chat(
      parameters: {
        model: 'gpt-4', # You can use 'gpt-3.5-turbo' for GPT-3.5
        messages: [
            { role: "system", content: "Você é um assistente útil que categoriza tarefas com base no título." },
            { role: "user", content: prompt }
          ],
        temperature: 0.7
      }
    )
  
      # Extrair a resposta
      if response && response['choices'] && response['choices'].first['message']
        mood_response = response['choices'].first['message']['content'].strip.capitalize
        mood = Mood.find_by(name: mood_response)
  
        if mood
          card.update(mood: mood)
        else
          Rails.logger.error "Humor '#{mood_response}' não encontrado para o card ID #{card_id}."
        end
      else
        Rails.logger.error "Falha ao obter resposta do OpenAI para o card ID #{card_id}."
      end
    rescue => e
      Rails.logger.error "Erro em AssignMoodJob para o card ID #{card_id}: #{e.message}"
    end
  end
  