# frozen_string_literal: true

require "elephant_in_the_room/the_one_api_sdk/api_paths/all_paths"
require "elephant_in_the_room/the_one_api_sdk/pipeline/pipeline_modifiers"

module ElephantInTheRoom::TheOneApiSdk
  ##
  # All modifiers that can modify the SDK behavior
  module Modifiers
    ##
    # Replaces the default retry strategy
    def with_retry_strategy(retry_strategy)
      new_retry_stage = lambda { |next_stage|
        ElephantInTheRoom::TheOneApiSdk::Pipeline::Retry.new(next_stage, retry_strategy)
      }
      new_pipeline = replace_existing_stage(@pipeline, :retry, new_retry_stage)
      modified_sdk = ElephantInTheRoom::TheOneApiSdk::ModifiedSdk.new(new_pipeline)
      if block_given?
        yield(modified_sdk)
      else
        modified_sdk
      end
    end

    def paginated(limit: nil, page: nil, offset: nil)
      with_pagination(@pipeline, limit: limit, page: page, offset: offset) do |paginated_pipeline|
        modified_sdk = ElephantInTheRoom::TheOneApiSdk::ModifiedSdk.new(paginated_pipeline)
        if block_given?
          yield(modified_sdk)
        else
          modified_sdk
        end
      end
    end
  end

  ##
  # An instance of the SDK with modified behavior
  class ModifiedSdk
    include Modifiers
    include ElephantInTheRoom::TheOneApiSdk::ApiPaths::AllPaths
    include ElephantInTheRoom::TheOneApiSdk::Pipeline::PipelineModifiers

    def initialize(pipeline)
      @pipeline = pipeline
    end
  end
end
