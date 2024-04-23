class Room < ApplicationRecord
    belongs_to :building
    has_many :room_snapshots
    has_many :elements
    
    validates :room_type, presence: true
    validates :total_cost, numericality: { greater_than_or_equal_to: 0 }
    validates :total_budget, numericality: { greater_than_or_equal_to: 0 }
    validate :total_cost_within_budget

    def total_cost_within_budget
        errors.add(:total_cost, "room exceeds total budget") if total_cost > total_budget
    end
end