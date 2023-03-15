module MichaelTaylorSdk::Pipeline
  class ResponseBody
    def initialize(next_pipeline_stage)
      @next_pipeline_stage = next_pipeline_stage
    end

    def execute_http_request(request_details)
      @next_pipeline_stage.execute_http_request(request_details)
    end

    def http_body
      @next_pipeline_stage.http_response.body
    end
  end
end