# frozen_string_literal: true

class RequestDistributionBlueprint < Base
  # Fields
  fields :bench_id, :plant_stage_id, :pot_id, :pot_quantity, :area

  field :greenhouse_id do |request_distribution|
    request_distribution.bench&.greenhouse_id
  end
end
