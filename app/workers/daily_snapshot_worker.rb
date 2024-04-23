class DailySnapshotWorker
    include Sidekiq::Worker
    include SnapshotHandler
    
    def perform(building_id = nil, room_id = nil)
        if building_id.present?
            take_building_snapshot(building_id)
        elsif room_id.present?
            take_room_snapshot(room_id)
        else
            raise ArgumentError, "No building or room id provided"
        end
    end

    private 

    def take_building_snapshot(building_id)
        begin
            building = Building.find(building_id)
            building.create_building_snapshot
        rescue ActiveRecord::RecordNotFound
            puts "Building with ID #{building_id} not found."
        end
    end

    def take_room_snapshot(room_id)
        begin
          room = Room.find(room_id)
          room.create_building_snapshot
        rescue ActiveRecord::RecordNotFound
          puts "Room with ID #{room_id} not found."
        end
    end
end