class Client < ApplicationRecord
	validates :name, :cpf, :phone, presence: true
	has_many :sale
end
