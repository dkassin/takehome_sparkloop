module SnapshotHandler
    def self.create_room_snapshot(room)
        begin
            RoomSnapshot.create!(room_id: room.id, snapshot_date: Date.today, total_cost: room.total_cost, status: room.status)
        rescue StandardError => e
            Rails.logger.error "Error creating room snapshot: #{e.message}"
            nil
        end
    end

    def self.create_building_snapshot(building)
        begin
            BuildingSnapshot.create!(building_id: building.id, snapshot_date: Date.today, total_cost: building.total_cost, status: building.status)
        rescue StandardError => e
            Rails.logger.error "Error creating building snapshot: #{e.message}"
            nil
        end
    end

    def self.snapshots_for_date(date, room_id = nil, building_id = nil)
        if room_id.present? 
            RoomSnapshot.where(snapshot_date: date, room_id: room_id)
        elsif building_id.present? 
            BuildingSnapshot.where(snapshot_date: date, building_id: building_id)
        else
            raise ArgumentError, "No building or room id provided"
        end
    rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error "No snapshots found: #{e.message}"
        []
    end
end
