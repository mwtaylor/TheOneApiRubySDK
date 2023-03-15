# frozen_string_literal: true

require "michael_taylor_sdk/api_paths/all_paths"
require "michael_taylor_sdk/pipeline/pipeline_modifiers"

module MichaelTaylorSdk
  ##
  # All modifiers that can modify the SDK behavior
  module Modifiers
    ##
    # Replaces the default retry strategy
    def with_retry_strategy(retry_strategy)
      new_retry_stage = lambda { |next_stage|
        MichaelTaylorSdk::Pipeline::Retry.new(next_stage, retry_strategy)
      }
      new_pipeline = replace_existing_stage(@pipeline, :retry, new_retry_stage)
      modified_sdk = MichaelTaylorSdk::ModifiedSdk.new(new_pipeline)
      if block_given?
        yield(modified_sdk)
      else
        modified_sdk
      end
    end

    def paginated(limit: nil, page: nil, offset: nil)
      with_pagination(@pipeline, limit: limit, page: page, offset: offset) do |paginated_pipeline|
        modified_sdk = MichaelTaylorSdk::ModifiedSdk.new(paginated_pipeline)
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
    include MichaelTaylorSdk::ApiPaths::AllPaths
    include MichaelTaylorSdk::Pipeline::PipelineModifiers

    def initialize(pipeline)
      @pipeline = pipeline
    end
  end
end
