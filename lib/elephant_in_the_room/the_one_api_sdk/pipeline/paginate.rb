# frozen_string_literal: true

module ElephantInTheRoom::TheOneApiSdk::Pipeline
  ##
  # Pipeline stage that adds pagination parameters and adds pagination details into response
  class Paginate
    def initialize(next_pipeline_stage, limit: nil, page: nil, offset: nil)
      @next_pipeline_stage = next_pipeline_stage
      @limit = limit
      @page = page
      @offset = offset
    end

    def execute_http_request(request_details)
      request_details[:query_parameters] = {} unless request_details.key?(:query_parameters)
      request_details[:query_parameters]["limit"] = @limit unless @limit.nil?
      request_details[:query_parameters]["page"] = @page unless @page.nil?
      request_details[:query_parameters]["offset"] = @offset unless @offset.nil?

      @next_pipeline_stage.execute_http_request(request_details)
    end

    def result_hash
      next_result = @next_pipeline_stage.result_hash

      {
        items: next_result[:docs],
        pagination: next_result.slice(:total, :limit, :offset, :page, :pages),
      }
    end
  end
end
