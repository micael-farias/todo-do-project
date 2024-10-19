class User < ApplicationRecord  
  has_many :user_moods, dependent: :destroy
  has_many :moods, through: :user_moods
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   
  has_many :boards, dependent: :destroy  # Um usuário tem muitos Boards

end
