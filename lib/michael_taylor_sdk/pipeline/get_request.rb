# frozen_string_literal: true

require "uri"
require "net/http"

module MichaelTaylorSdk::Pipeline
  class GetRequest
    HEADER_AUTHORIZATION = "Authorization"
    AUTHENTICATION_SCHEME_BEARER = "Bearer"

    def initialize(base_url, authorization_token)
      @base_url = base_url
      @authorization_token = authorization_token
    end

    def query_string(request_details)
      request_details[:query_parameters]
        .map { |key, value| "#{key}=#{value}" }
        .join("&")
    end

    def uri(request_details)
      uri = "#{@base_url}/#{request_details[:path]}"
      uri += "?#{query_string(request_details)}" if request_details.key?(:query_parameters)
      URI(uri)
    end

    def add_headers(request)
      request[HEADER_AUTHORIZATION] = "#{AUTHENTICATION_SCHEME_BEARER} #{@authorization_token}"
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
  end
end
