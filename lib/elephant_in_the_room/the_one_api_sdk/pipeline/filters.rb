# frozen_string_literal: true

module ElephantInTheRoom::TheOneApiSdk::Pipeline
  ##
  # Pipeline stage that adds filters to list requests
  class Filters
    def initialize(next_pipeline_stage, filters)
      @next_pipeline_stage = next_pipeline_stage
      @filters = filters
    end

    def execute_http_request(request_details)
      request_details[:query_parameters] = {} unless request_details.key?(:query_parameters)
      @filters.each do |filter|
        request_details[:query_parameters][filter] = nil
      end

      @next_pipeline_stage.execute_http_request(request_details)
    end

    def result_hash
      @next_pipeline_stage.result_hash
    end
  end
end
