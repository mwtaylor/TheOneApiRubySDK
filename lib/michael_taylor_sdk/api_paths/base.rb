

module MichaelTaylorSdk::ApiPaths
  class Base
    attr_reader :pipeline

    def initialize(pipeline)
      @pipeline = pipeline
    end

    def list
      pipeline = @pipeline.call()
      stages = pipeline[:stages].map { |stage_key| pipeline[stage_key] }
      next_stage = nil
      stages.reverse.each do |stage_initializer|
        if next_stage.nil?
          next_stage = stage_initializer.call()
        else
          next_stage = stage_initializer.call(next_stage)
        end
      end
      next_stage.execute_http_request({})
      next_stage.result_hash
    end
  end
end