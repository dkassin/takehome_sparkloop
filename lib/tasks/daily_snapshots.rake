namespace :daily_snapshots do
    desc "Take daily snapshots of building and rooms"

    # A cronjob would run every day at a given time. 
    task :take => :environment do
        Building.where(status: 'in_progress').each do |building|
            TakeDailySnapshotWorker.perform_async(building.id, nil) 
        end

        Room.where(status: 'in_progress').each do |room|
            TakeDailySnapshotWorker.perform_async(nil, room.id)
        end 
        
        puts "Daily snapshots taken successfully."
    end 
end