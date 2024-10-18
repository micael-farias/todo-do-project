class Mood < ApplicationRecord
    has_many :cards, dependent: :nullify

    validates :name, presence: true, uniqueness: true
end
