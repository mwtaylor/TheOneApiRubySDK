# frozen_string_literal: true

require "michael_taylor_sdk/api_paths/movies"

module MichaelTaylorSdk::ApiPaths
  ##
  # Mixin to add all available API paths to the parent object
  module AllPaths
    ##
    # Provides queries related to movies
    def movies
      MichaelTaylorSdk::ApiPaths::Movies.new(@pipeline)
    end
  end
end
