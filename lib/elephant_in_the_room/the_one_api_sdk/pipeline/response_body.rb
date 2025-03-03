# frozen_string_literal: true

module ElephantInTheRoom::TheOneApiSdk::Pipeline
  ##
  # Pipeline stage to get body content from HTTP response
  class ResponseBody
    def initialize(next_pipeline_stage)
      @next_pipeline_stage = next_pipeline_stage
    end

    def execute_http_request(request_details)
      @next_pipeline_stage.execute_http_request(request_details)
    end

    def http_body
      body = @next_pipeline_stage.http_response.body
      raise ElephantInTheRoom::TheOneApiSdk::Errors::NoContentError, "Server response was empty" if body.empty?

      body
    end
  end
end
