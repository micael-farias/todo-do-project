class BoardCard < ApplicationRecord
  belongs_to :board
  belongs_to :card

  validates :board_id, uniqueness: { scope: :card_id } # Evita duplicação de associações
end
