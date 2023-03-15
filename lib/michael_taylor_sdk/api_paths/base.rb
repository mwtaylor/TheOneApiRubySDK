# frozen_string_literal: true

module MichaelTaylorSdk::ApiPaths
  class Base
    attr_reader :pipeline

    def initialize(pipeline)
      @pipeline = pipeline
    end

    def list
      pipeline = @pipeline.call
      stage_initializers = pipeline[:stages].map { |stage_key| pipeline[stage_key] }
      next_stage = initialize_pipeline_stages(stage_initializers)
      next_stage.execute_http_request({})
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