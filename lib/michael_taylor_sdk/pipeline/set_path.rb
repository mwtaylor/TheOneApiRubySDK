# frozen_string_literal: true

module MichaelTaylorSdk::Pipeline
  class SetPath
    def initialize(next_pipeline_stage, path)
      @next_pipeline_stage = next_pipeline_stage
      @path = path
    end

    def execute_http_request(request_details)
      request_details[:path] = @path

      @next_pipeline_stage.execute_http_request(request_details)
    end

    def http_response
      @next_pipeline_stage.http_response
    end
  end
end
