# frozen_string_literal: true

require "elephant_in_the_room/the_one_api_sdk/api_paths/movies"

module ElephantInTheRoom::TheOneApiSdk::ApiPaths
  ##
  # Mixin to add all available API paths to the parent object
  module AllPaths
    ##
    # Provides queries related to movies
    def movies
      ElephantInTheRoom::TheOneApiSdk::ApiPaths::Movies.new(@pipeline)
    end
  end
end
