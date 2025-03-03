# frozen_string_literal: true

require "elephant_in_the_room/the_one_api_sdk/errors"

module ElephantInTheRoom::TheOneApiSdk::Pipeline
  ##
  # Pipeline stage that raises errors when the HTTP response is a 4xx or 5xx error
  class RaiseHttpErrors
    def initialize(next_pipeline_stage)
      @next_pipeline_stage = next_pipeline_stage
    end

    def execute_http_request(request_details)
      response = @next_pipeline_stage.execute_http_request(request_details)
      if response.is_a? Net::HTTPServerError
        raise ElephantInTheRoom::TheOneApiSdk::Errors::ServerError, response
      elsif response.is_a? Net::HTTPClientError
        raise ElephantInTheRoom::TheOneApiSdk::Errors::ClientError, response
      end
    end

    def http_response
      @next_pipeline_stage.http_response
    end
  end
end
