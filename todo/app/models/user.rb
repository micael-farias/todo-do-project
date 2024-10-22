class User < ApplicationRecord  
  has_many :user_moods, dependent: :destroy
  has_many :moods, through: :user_moods
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  belongs_to :mood_category, optional: true
  after_create :initialize_user_moods

  has_many :boards, dependent: :destroy  # Um usuário tem muitos Boards
  # Associações com Boards
  # Associações Indiretas para BoardItems e Cards
  has_many :board_items, through: :boards
  has_many :cards, through: :board_items
  has_one_attached :avatar
  has_many :parameters, dependent: :destroy

  def initialize_user_moods
    # Mood.find_each do |mood|
     # self.user_moods.create(mood: mood, active: false) # Define `active` conforme necessário
    #end

    daily_board = self.boards.create(title: "Board Diário", active: false)

    # Criar as duas colunas: To Do e Done
    todo_column = daily_board.board_items.create(name: 'To Do', position: 1)
    done_column = daily_board.board_items.create(name: 'Done', position: 2)
  end

  def active_theme_mood
    active_mood = user_moods.find_by(active: true)
    return nil unless active_mood

    theme_mood = ThemeMood.find_by(mood: active_mood.mood, mood_category: mood_category)
    theme_mood
  end
end
