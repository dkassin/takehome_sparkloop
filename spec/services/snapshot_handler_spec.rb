require 'rails_helper'

RSpec.describe SnapshotHandler do
    describe '#create_room_snapshot' do
        before(:each) do
            @contractor = Contractor.create(name: "Contractor 1", phone_number: "1234567890", email: "email@email.com")
            @building = Building.create(contractor: @contractor, name: "Building A", address: "123 Main St", total_budget: 50000, total_cost: 0, status: "in_progress", start_date: Date.today)
            @room = Room.create(building: @building, room_type: "Bedroom", total_cost: 0, total_budget: 20000, status: "in_progress", start_date: Date.today)
            @element = Element.create(room: @room, element_type: "Floor", cost: 1000)
        end

        it 'creates a room snapshot with correct attributes' do
            expect { SnapshotHandler::create_room_snapshot(@room) }.to change(RoomSnapshot, :count).by(1)
        end

        it 'sets the correct attributes for the room snapshot' do
            SnapshotHandler::create_room_snapshot(@room)

            expect(RoomSnapshot.last.room_id).to eq(@room.id)
            expect(RoomSnapshot.last.snapshot_date).to eq(Date.today)
        end

        it 'raises an error and does not create a room snapshot if creation fails' do
            allow(RoomSnapshot).to receive(:create!).and_raise(StandardError)
            allow(Rails.logger).to receive(:error)

            expect(SnapshotHandler.create_room_snapshot(@room)).to be_nil
            expect(Rails.logger).to have_received(:error).with("Error creating room snapshot: StandardError")
        end
    end 

    describe '#create_building_snapshot' do
        before(:each) do
            @contractor = Contractor.create(name: "Contractor 1", phone_number: "1234567890", email: "email@email.com")
            @building = Building.create(contractor: @contractor, name: "Building A", address: "123 Main St", total_budget: 50000, total_cost: 0, status: "in_progress", start_date: Date.today)
            @room = Room.create(building: @building, room_type: "Bedroom", total_cost: 0, total_budget: 20000, status: "in_progress", start_date: Date.today)
            @element = Element.create(room: @room, element_type: "Floor", cost: 1000)
        end

        it 'creates a room snapshot with correct attributes' do
            expect { SnapshotHandler::create_building_snapshot(@building) }.to change(BuildingSnapshot, :count).by(1)
        end

        it 'sets the correct attributes for the room snapshot' do
            SnapshotHandler::create_building_snapshot(@building)

            expect(BuildingSnapshot.last.building_id).to eq(@building.id)
            expect(BuildingSnapshot.last.snapshot_date).to eq(Date.today)
        end

        it 'raises an error and does not create a room snapshot if creation fails' do
            allow(BuildingSnapshot).to receive(:create!).and_raise(StandardError)
            allow(Rails.logger).to receive(:error)

            expect(SnapshotHandler.create_building_snapshot(@building)).to be_nil
            expect(Rails.logger).to have_received(:error).with("Error creating building snapshot: StandardError")
        end
    end 

    describe '#snapshots_for_date' do
        before(:each) do
        @contractor = Contractor.create(name: "Contractor 1", phone_number: "1234567890", email: "email@email.com")
        @building = Building.create(contractor: @contractor, name: "Building A", address: "123 Main St", total_budget: 50000, total_cost: 0, status: "in_progress", start_date: Date.today)
        @room = Room.create(building: @building, room_type: "Bedroom", total_cost: 0, total_budget: 20000, status: "in_progress", start_date: Date.today)
        @element = Element.create(room: @room, element_type: "Floor", cost: 1000)
        end

        context 'when a valid room_id is provided' do
            it 'returns room snapshots for the given date' do
                RoomSnapshot.create(room_id: @room.id, snapshot_date: Date.today)

                expect(SnapshotHandler.snapshots_for_date(Date.today, @room.id)).to eq([@room.room_snapshots.first])
            end
        end

        context 'when a valid building_id is provided' do
            it 'returns building snapshots for the given date' do
                BuildingSnapshot.create(building_id: @building.id, snapshot_date: Date.today)

                expect(SnapshotHandler.snapshots_for_date(Date.today, nil, @building.id)).to eq([@building.building_snapshots.first])
            end
        end

        context 'when neither room_id nor building_id is provided' do
            it 'raises an ArgumentError' do
                expect { SnapshotHandler.snapshots_for_date(Date.today) }.to raise_error(ArgumentError, "No building or room id provided")
            end
        end

        context 'when no snapshots are found' do
            it 'returns an empty array' do
                allow(RoomSnapshot).to receive(:where).and_return([])
            
                expect(SnapshotHandler.snapshots_for_date(Date.today, 9999)).to eq([])
            end
        end
    end
end