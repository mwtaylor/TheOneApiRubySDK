# frozen_string_literal: true

require "elephant_in_the_room/the_one_api_sdk/version"

require "elephant_in_the_room/the_one_api_sdk/pipeline/pipeline_modifiers"
require "elephant_in_the_room/the_one_api_sdk/pipeline/paginate"
require "elephant_in_the_room/the_one_api_sdk/pipeline/filters"
require "elephant_in_the_room/the_one_api_sdk/pipeline/json"
require "elephant_in_the_room/the_one_api_sdk/pipeline/response_body"
require "elephant_in_the_room/the_one_api_sdk/pipeline/retry"
require "elephant_in_the_room/the_one_api_sdk/pipeline/raise_http_errors"
require "elephant_in_the_room/the_one_api_sdk/pipeline/get_request"
require "elephant_in_the_room/the_one_api_sdk/api_paths/all_paths"
require "elephant_in_the_room/the_one_api_sdk/modified_sdk"
require "elephant_in_the_room/the_one_api_sdk/constants"

module ElephantInTheRoom::TheOneApiSdk
  ##
  # Entry point into the SDK
  class TheOne
    include ElephantInTheRoom::TheOneApiSdk::Pipeline::PipelineModifiers
    include ElephantInTheRoom::TheOneApiSdk::ApiPaths::AllPaths
    include ElephantInTheRoom::TheOneApiSdk::Modifiers

    DEFAULT_BASE_URL = "https://the-one-api.dev/v2"

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def initialize(
      access_token,
      base_url: DEFAULT_BASE_URL,
      default_retry_strategy: ElephantInTheRoom::TheOneApiSdk::RetryStrategy::OneTry.new
    )
      raise "Access token must be given as a string" unless access_token.is_a? String

      @default_pipeline = lambda {
        {
          paginate: ->(next_stage) { ElephantInTheRoom::TheOneApiSdk::Pipeline::Paginate.new(next_stage) },
          filter: ->(next_stage) { ElephantInTheRoom::TheOneApiSdk::Pipeline::Filters.new(next_stage, []) },
          json: ->(next_stage) { ElephantInTheRoom::TheOneApiSdk::Pipeline::Json.new(next_stage) },
          response_body: ->(next_stage) { ElephantInTheRoom::TheOneApiSdk::Pipeline::ResponseBody.new(next_stage) },
          set_path: ->(next_stage) {},
          retry: lambda { |next_stage|
            ElephantInTheRoom::TheOneApiSdk::Pipeline::Retry.new(next_stage, default_retry_strategy)
          },
          raise_http_errors: lambda { |next_stage|
            ElephantInTheRoom::TheOneApiSdk::Pipeline::RaiseHttpErrors.new(next_stage)
          },
          get_request: -> { ElephantInTheRoom::TheOneApiSdk::Pipeline::GetRequest.new(base_url, access_token) },
          stages: %i[paginate filter json response_body set_path retry raise_http_errors get_request],
        }
      }

      @pipeline = @default_pipeline
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  end
end
