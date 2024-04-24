require 'rails_helper'

RSpec.describe Element, type: :model do
  describe "#update_related_costs" do
    before(:each) do
        @contractor = Contractor.create(name: "Contractor 1", phone_number: "1234567890", email: "email@email.com")
        @building = Building.create(contractor: @contractor, name: "Building A", address: "123 Main St", total_budget: 50000, total_cost: 0, status: "in_progress", start_date: Date.today)
        @room = Room.create(building: @building, room_type: "Bedroom", total_cost: 0, total_budget: 20000, status: "in_progress", start_date: Date.today)
        @element = Element.create(room: @room, element_type: "Floor", cost: 1000)
    end

    context "when all validations pass" do
      it "updates related costs" do
        expect(@room).to receive(:save).once
        expect(@building).to receive(:save).once

        @element.update_related_costs

        expect(@room.total_cost).to eq(1000)
        expect(@building.total_cost).to eq(1000)
      end

      it "returns true" do
        expect(@element.update_related_costs).to eq(true)
      end
    end

    context "when room validation fails" do
      before do
        allow(@room).to receive(:valid?).and_return(false)
      end

      it "does not update related costs" do
        expect(@room).not_to receive(:save)
        expect(@building).not_to receive(:save)

        @element.update_related_costs

        expect(@room.reload.total_cost).to eq(0)
        expect(@building.reload.total_cost).to eq(0)
      end

      it "returns false" do
        expect(@element.update_related_costs).to eq(false)
      end
    end

    context "when building validation fails" do
      before do
        allow(@building).to receive(:valid?).and_return(false)
      end

      it "does not update related costs" do
        expect(@room).not_to receive(:save)
        expect(@building).not_to receive(:save)

        @element.update_related_costs

        expect(@room.reload.total_cost).to eq(0)
        expect(@building.reload.total_cost).to eq(0)
      end

      it "returns false" do
        expect(@element.update_related_costs).to eq(false)
      end
    end
  end
end