class User < ApplicationRecord  
  # Devise Modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable

  # Associations
  belongs_to :mood_category, optional: true
  has_many :user_moods, dependent: :destroy
  has_many :moods, through: :user_moods
  has_many :boards, dependent: :destroy
  has_many :board_items, through: :boards
  has_many :cards, through: :board_items
  has_one_attached :avatar
  has_many :parameters, dependent: :destroy

  # Callbacks
  after_create :initialize_user_moods_and_daily_board

  # Instance Methods

  # Retorna o theme_mood ativo do usuário
  def active_theme_mood
    active_mood = user_moods.find_by(active: true)
    return nil unless active_mood

    ThemeMood.find_by(mood: active_mood.mood, mood_category: mood_category)
  end

  # Retorna os humores ativos do usuário no dia atual
  def active_moods_today
    user_moods.where(updated_at: Date.current.all_day, active: true)
  end

  private

  # Inicializa os humores do usuário e cria o board diário padrão
  def initialize_user_moods_and_daily_board
    initialize_user_moods
    create_daily_board
  end

  # Cria humores para o usuário
  def initialize_user_moods
    Mood.find_each do |mood|
      user_moods.create(mood: mood, active: false) # Define todos os humores como inativos inicialmente
    end
  end

  # Cria o board diário padrão com as colunas "To Do" e "Done"
  def create_daily_board
    daily_board = boards.create(title: "Board Diário", active: false)

    daily_board.board_items.create(name: 'To Do', position: 1)
    daily_board.board_items.create(name: 'Done', position: 2)
  end
end
