class ScientistsController < ApplicationController
    wrap_parameters format: []
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_uprocessable_entity


    def index 
        render json: Scientist.all, status: :ok
    end

    def show 
        scientist = Scientist.find(params[:id])
        render json: scientist, serializer: ScientistWithPlanetsSerializer
    end

    def create 
        new_scientist = Scientist.create!(scientist_params)
        render json: new_scientist, status: :created
    end

    def update
        scientist = Scientist.find(params[:id])
        scientist_updates = scientist.update!(scientist_params)
        render json: scientist, status: :accepted
    end

    def destroy
        scientist = Scientist.find_by(id: params[:id])
        if scientist
            scientist.destroy
            head :no_content
        else 
            render json: {error: "Scientist not found"}, status: :not_found
        end
    end

    private 

    def render_record_not_found
        render json:{ error: "Scientist not found" }, status: :not_found
    end

    def render_uprocessable_entity(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def scientist_params
        params.permit(:name, :field_of_study, :avatar)
    end
end
