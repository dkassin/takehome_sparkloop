class Element < ApplicationRecord
    belongs_to :room

    validates :element_type, presence: true
    validates :cost, presence: true

    def update_related_costs
        cost_to_add = self.cost
        
        room.total_cost += cost_to_add
        room.building.total_cost += cost_to_add
        
        if room.valid? && room.building.valid?
          room.save
          room.building.save
        else
            return false
        end
        return true 
    end
end