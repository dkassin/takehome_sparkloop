class ElementsController < ApplicationController
    def create
        Element.transaction do 
            @element = Element.new(element_params)
            
            if @element.valid? 
                if @element.update_related_costs
                    @element.save
                    SnapshotHandler.create_room_snapshot(@element.room)
                    head :ok
                else 
                    render json: { error: 'Failed to create element' }, status: :unprocessable_entity
                end
            else
                render json: { error: @element.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end

    private

    def element_params
        params.require(:element).permit(:element_type, :cost, :room_id)
    end
end