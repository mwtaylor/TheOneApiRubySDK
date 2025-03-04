# frozen_string_literal: true

require "uri"
require "net/http"

module ElephantInTheRoom::TheOneApiSdk::Pipeline
  ##
  # Final pipeline stage that sends an HTTP request to the server
  class GetRequest
    HEADER_AUTHORIZATION = "Authorization"
    AUTHENTICATION_SCHEME_BEARER = "Bearer"

    def initialize(base_url, authorization_token)
      @base_url = base_url
      @authorization_token = authorization_token
    end

    def execute_http_request(request_details)
      request = Net::HTTP::Get.new(uri(request_details))
      add_headers(request)

      @response = Net::HTTP.start(request.uri.hostname, use_ssl: true) do |http|
        http.request(request)
      end
    end

    def http_response
      @response
    end

    private

    def query_string(request_details)
      request_details[:query_parameters]
        .map { |key, value| value.nil? ? key : "#{key}=#{value}" }
        .join("&")
    end

    def uri(request_details)
      uri = "#{@base_url}/#{request_details[:path]}"
      if request_details.key?(:query_parameters) && !request_details[:query_parameters].empty?
        uri += "?#{query_string(request_details)}"
      end
      URI(uri)
    end

    def add_headers(request)
      request[HEADER_AUTHORIZATION] = "#{AUTHENTICATION_SCHEME_BEARER} #{@authorization_token}"
    end
  end
end
