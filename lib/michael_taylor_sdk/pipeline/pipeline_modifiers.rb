# frozen_string_literal: true

module MichaelTaylorSdk::Pipeline
  ##
  # Common methods to work with pipelines
  module PipelineModifiers
    ##
    # Replace a stage in a pipeline with a modified version with different parameters
    def replace_existing_stage(pipeline, next_stage_key, next_stage_lambda)
      lambda {
        modified_pipeline = pipeline.call
        modified_pipeline[next_stage_key] = next_stage_lambda
        modified_pipeline
      }
    end
  end
end
