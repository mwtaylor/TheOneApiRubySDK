# frozen_string_literal: true

require "michael_taylor_sdk/version"

require "michael_taylor_sdk/pipeline/pipeline_modifiers"
require "michael_taylor_sdk/pipeline/paginate"
require "michael_taylor_sdk/pipeline/json"
require "michael_taylor_sdk/pipeline/response_body"
require "michael_taylor_sdk/pipeline/get_request"
require "michael_taylor_sdk/api_paths/movies"

module MichaelTaylorSdk
  class LordOfTheRings
    include MichaelTaylorSdk::Pipeline::PipelineModifiers

    DEFAULT_BASE_URL = "https://the-one-api.dev/v2"

    def initialize(access_token, base_url: DEFAULT_BASE_URL)
      @default_pipeline = lambda {
        {
          paginate: ->(next_stage) { MichaelTaylorSdk::Pipeline::Paginate.new(next_stage) },
          json: ->(next_stage) { MichaelTaylorSdk::Pipeline::Json.new(next_stage) },
          response_body: ->(next_stage) { MichaelTaylorSdk::Pipeline::ResponseBody.new(next_stage) },
          set_path: ->(next_stage) {},
          get_request: -> { MichaelTaylorSdk::Pipeline::GetRequest.new(base_url, access_token) },
          stages: %i[paginate json response_body set_path get_request]
        }
      }
    end

    def movies
      MichaelTaylorSdk::ApiPaths::Movies.new(@default_pipeline)
    end
  end
end
