# frozen_string_literal: true

require "michael_taylor_sdk/api_paths/movies"

module MichaelTaylorSdk::ApiPaths
  module AllPaths
    def movies
      MichaelTaylorSdk::ApiPaths::Movies.new(@pipeline)
    end
  end
end
