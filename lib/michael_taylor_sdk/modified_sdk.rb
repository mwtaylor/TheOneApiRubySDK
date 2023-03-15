# frozen_string_literal: true

require "michael_taylor_sdk/api_paths/all_paths"
require "michael_taylor_sdk/pipeline/pipeline_modifiers"

module MichaelTaylorSdk
  module Modifiers
    def with_retry_strategy(retry_strategy)
      new_pipeline = replace_existing_stage(@pipeline, :retry, ->(next_stage) { MichaelTaylorSdk::Pipeline::Retry.new(next_stage, retry_strategy) })
      MichaelTaylorSdk::ModifiedSdk.new(new_pipeline)
    end
  end

  class ModifiedSdk
    include Modifiers
    include MichaelTaylorSdk::ApiPaths::AllPaths
    include MichaelTaylorSdk::Pipeline::PipelineModifiers

    def initialize(pipeline)
      @pipeline = pipeline
    end
  end
end
