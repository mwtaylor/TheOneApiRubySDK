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

    def with_path(pipeline, path)
      yield replace_existing_stage(
        pipeline,
        :set_path,
        ->(next_stage) { MichaelTaylorSdk::Pipeline::SetPath.new(next_stage, path) }
      )
    end

    def with_filters(pipeline, filters)
      yield replace_existing_stage(
        pipeline,
        :filter,
        ->(next_stage) { MichaelTaylorSdk::Pipeline::Filters.new(next_stage, filters) }
      )
    end

    def with_pagination(pipeline, limit: nil, page: nil, offset: nil)
      new_paginate_stage = lambda { |next_stage|
        MichaelTaylorSdk::Pipeline::Paginate.new(next_stage, limit: limit, page: page, offset: offset)
      }
      yield replace_existing_stage(pipeline, :paginate, new_paginate_stage)
    end
  end
end
