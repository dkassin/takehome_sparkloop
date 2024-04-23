class Building < ApplicationRecord
    belongs_to :contractor
    has_many :building_snapshots
    has_many :rooms

    validate :total_cost_within_budget

    def total_cost_within_budget
        errors.add(:total_cost, "building exceeds total budget") if total_cost > total_budget
    end
end