# frozen_string_literal: true

require "michael_taylor_sdk/pipeline/pipeline_modifiers"

module MichaelTaylorSdk::ApiPaths
  ##
  # Provides common methods for all API paths
  class Base
    include MichaelTaylorSdk::Pipeline::PipelineModifiers

    attr_reader :pipeline

    def initialize(pipeline)
      @pipeline = pipeline
    end

    ##
    # List all items
    def list
      pipeline = @pipeline.call
      stage_initializers = pipeline[:stages].map { |stage_key| pipeline[stage_key] }
      next_stage = initialize_pipeline_stages(stage_initializers)
      next_stage.execute_http_request({})
      next_stage.result_hash
    end

    protected

    def initialize_pipeline_stages(stage_initializers)
      next_stage = nil
      stage_initializers.reverse.each do |stage_initializer|
        next_stage = if next_stage.nil?
                       stage_initializer.call
                     else
                       stage_initializer.call(next_stage)
                     end
      end
      next_stage
    end
  end
end
