# frozen_string_literal: true

module MichaelTaylorSdk::Pipeline
  module PipelineModifiers
    def replace_existing_stage(pipeline, next_stage_key, next_stage_lambda)
      lambda {
        modified_pipeline = pipeline.call
        modified_pipeline[next_stage_key] = next_stage_lambda
        modified_pipeline
      }
    end
  end
end
