# frozen_string_literal: true

require "michael_taylor_sdk/errors"

module MichaelTaylorSdk::Pipeline


  class RaiseHttpErrors
    def initialize(next_pipeline_stage)
      @next_pipeline_stage = next_pipeline_stage
    end

    def execute_http_request(request_details)
      response = @next_pipeline_stage.execute_http_request(request_details)
      if response.is_a? Net::HTTPServerError
        raise MichaelTaylorSdk::Errors::ServerError.new(response)
      elsif response.is_a? Net::HTTPClientError
        raise MichaelTaylorSdk::Errors::ClientError.new(response)
      end
    end

    def http_response
      @next_pipeline_stage.http_response
    end
  end
end
