require 'json'

module MichaelTaylorSdk::Pipeline
  class Json
    def initialize(next_pipeline_stage)
      @next_pipeline_stage = next_pipeline_stage
    end

    def execute_http_request(request_details)
      @result = @next_pipeline_stage.execute_http_request(request_details)
    end

    def result_hash
      JSON.parse(@next_pipeline_stage.http_body, symbolize_names: true)
    end
  end
end
