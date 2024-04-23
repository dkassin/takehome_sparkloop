require 'rails_helper'

RSpec.describe ElementsController, type: :controller do
    describe "POST #create" do
        before(:each) do
            @contractor = Contractor.create(name: "Contractor 1", phone_number: "1234567890", email: "email@email.com")
            @building = Building.create(contractor: @contractor, name: "Building A", address: "123 Main St", total_budget: 50000, total_cost: 0, status: "in_progress", start_date: Date.today)
            @room = Room.create(building: @building, room_type: "Bedroom", total_cost: 0, total_budget: 20000, status: "in_progress", start_date: Date.today)
            @element = Element.create(room: @room, element_type: "Floor", cost: 1000)
        end
    
        context "with valid params" do
            it "creates a new element" do
                expect { post :create, params: { element: { element_type: "Floor", cost: 1000, room_id: @room.id } }}.to change(Element, :count).by(1)
            end

            it "updates the room's total cost" do
                post :create, params: { element: { element_type: "Floor", cost: 1000, room_id: @room.id } }
                @room.reload
                expect(@room.total_cost).to eq(1000)
            end
        
            it "updates the building's total cost" do
                post :create, params: { element: { element_type: "Floor", cost: 1000, room_id: @room.id } }
                @building.reload
                expect(@building.total_cost).to eq(1000)
            end

            it "calls SnapshotHandler.create_room_snapshot with the correct arguments" do
                expect(SnapshotHandler).to receive(:create_room_snapshot).with(@room)
                post :create, params: { element: { element_type: "Floor", cost: 1000, room_id: @room.id } }
            end
        
            it "returns a success response" do
                post :create, params: { element: { element_type: "Floor", cost: 1000, room_id: @room.id } }
                expect(response).to have_http_status(:ok)
            end
        end

        context "with invalid params" do
            it "returns an unprocessable entity response" do
                post :create, params: { element: { cost: 1000, room_id: @room.id } }  
                expect(response).to have_http_status(:unprocessable_entity)
            end

            it "returns an unprocessable entity response if costs exceed budget" do
                @room.update(total_budget: 1)
                
                post :create, params: { element: { element_type: "Floor", cost: 15000, room_id: @room.id } } 
                
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end
end