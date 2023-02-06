class MissionsController < ApplicationController
    wrap_parameters format: []
    rescue_from ActiveRecord::RecordInvalid, with: :render_uprocessable_entity

    def create
        new_mission = Mission.create!(mission_params)
        render json: new_mission.planet, status: :created
    end

    private 

    def render_uprocessable_entity(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def mission_params
        params.permit(:name, :scientist_id, :planet_id)
    end
end
