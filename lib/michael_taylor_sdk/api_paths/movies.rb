require_relative('base')

require "michael_taylor_sdk/pipeline/set_path"

module MichaelTaylorSdk::ApiPaths
  class Movies < Base
    include MichaelTaylorSdk::Pipeline::PipelineModifiers

    def initialize(pipeline)
      super(pipeline)
      @pipeline = replace_existing_stage(@pipeline, :set_path, -> (next_stage) { MichaelTaylorSdk::Pipeline::SetPath.new(next_stage, "movie") })
    end
  end
end