# frozen_string_literal: true

require "elephant_in_the_room/the_one_api_sdk/pipeline/pipeline_modifiers"

module ElephantInTheRoom::TheOneApiSdk::ApiPaths
  ##
  # Provides common methods for all API paths
  class Base
    include ElephantInTheRoom::TheOneApiSdk::Pipeline::PipelineModifiers

    attr_reader :pipeline

    def initialize(pipeline)
      @pipeline = pipeline
      @pipeline = replace_existing_stage(
        @pipeline,
        :set_path,
        ->(next_stage) { ElephantInTheRoom::TheOneApiSdk::Pipeline::SetPath.new(next_stage, path) }
      )
    end

    ##
    # List all items
    def list
      execute_pipeline(@pipeline, {})
    end

    def get(id)
      with_path(@pipeline, id_path(id)) do |pipeline|
        execute_pipeline(pipeline, {})
      end
    end

    protected

    def id_path(id)
      "#{path}/#{id}"
    end

    def execute_pipeline(pipeline_initializer, input)
      pipeline = pipeline_initializer.call
      stage_initializers = pipeline[:stages].map { |stage_key| pipeline[stage_key] }
      next_stage = initialize_pipeline_stages(stage_initializers)
      next_stage.execute_http_request(input)
      next_stage.result_hash
    end

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
