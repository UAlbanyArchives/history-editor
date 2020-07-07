class Subject < ApplicationRecord
	has_and_belongs_to_many :events

	validates :name, uniqueness: { case_sensitive: false }
end
