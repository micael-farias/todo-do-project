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
  has_one :user_preference, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :user_preference

  # Callbacks
  after_create :initialize_user_moods
  after_create :create_user_preference

  # Instance Methods

  # Retorna o theme_mood ativo do usuário
  def active_theme_mood
    return nil unless active_mood

    ThemeMood.find_by(mood: active_mood.mood, mood_category: mood_category)
  end

  def active_mood
    active_mood = user_moods.find_by(active: true)
  end

  # Retorna os humores ativos do usuário no dia atual
  def active_moods_today
    user_moods.where(updated_at: Date.current.all_day, active: true)
  end

  private

  # Cria humores para o usuário
  def initialize_user_moods
    Mood.find_each do |mood|
      user_moods.find_or_create_by(mood: mood) do |user_mood|
        user_mood.active = false # Define todos os humores como inativos inicialmente
      end
    end

    if mood_category.nil?
      update(mood_category: MoodCategory.last)
    end
  end

  def create_user_preference
    create_user_preference!(
      show_recent_boards: true,
      show_popular_boards: true,
      show_daily_board: true,
      show_card_priority: true,
      show_card_due_date: true,
      show_card_mood: true,
      show_form_after_create_card: true
    )
  end
end
