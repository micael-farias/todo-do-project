class User < ApplicationRecord  
  has_many :user_moods, dependent: :destroy
  has_many :moods, through: :user_moods
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :initialize_user_moods

  has_many :boards, dependent: :destroy  # Um usuário tem muitos Boards
  # Associações com Boards
  # Associações Indiretas para BoardItems e Cards
  has_many :board_items, through: :boards
  has_many :cards, through: :board_items
  has_one_attached :avatar

  def initialize_user_moods
    Mood.find_each do |mood|
      self.user_moods.create(mood: mood, active: false) # Define `active` conforme necessário
    end
  end
end
