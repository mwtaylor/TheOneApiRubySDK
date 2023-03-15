# frozen_string_literal: true

require "michael_taylor_sdk/version"

require "michael_taylor_sdk/pipeline/pipeline_modifiers"
require "michael_taylor_sdk/pipeline/paginate"
require "michael_taylor_sdk/pipeline/filters"
require "michael_taylor_sdk/pipeline/json"
require "michael_taylor_sdk/pipeline/response_body"
require "michael_taylor_sdk/pipeline/retry"
require "michael_taylor_sdk/pipeline/raise_http_errors"
require "michael_taylor_sdk/pipeline/get_request"
require "michael_taylor_sdk/api_paths/all_paths"
require "michael_taylor_sdk/modified_sdk"
require "michael_taylor_sdk/constants"

module MichaelTaylorSdk
  ##
  # Entry point into the SDK
  class LordOfTheRings
    include MichaelTaylorSdk::Pipeline::PipelineModifiers
    include MichaelTaylorSdk::ApiPaths::AllPaths
    include MichaelTaylorSdk::Modifiers

    DEFAULT_BASE_URL = "https://the-one-api.dev/v2"

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def initialize(
      access_token,
      base_url: DEFAULT_BASE_URL,
      default_retry_strategy: MichaelTaylorSdk::RetryStrategy::OneTry.new
    )

      raise "Access token must be given as a string" unless access_token.is_a? String

      @default_pipeline = lambda {
        {
          paginate: ->(next_stage) { MichaelTaylorSdk::Pipeline::Paginate.new(next_stage) },
          filter: ->(next_stage) { MichaelTaylorSdk::Pipeline::Filters.new(next_stage, []) },
          json: ->(next_stage) { MichaelTaylorSdk::Pipeline::Json.new(next_stage) },
          response_body: ->(next_stage) { MichaelTaylorSdk::Pipeline::ResponseBody.new(next_stage) },
          set_path: ->(next_stage) {},
          retry: ->(next_stage) { MichaelTaylorSdk::Pipeline::Retry.new(next_stage, default_retry_strategy) },
          raise_http_errors: ->(next_stage) { MichaelTaylorSdk::Pipeline::RaiseHttpErrors.new(next_stage) },
          get_request: -> { MichaelTaylorSdk::Pipeline::GetRequest.new(base_url, access_token) },
          stages: %i[paginate filter json response_body set_path retry raise_http_errors get_request],
        }
      }

      @pipeline = @default_pipeline
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  end
end
