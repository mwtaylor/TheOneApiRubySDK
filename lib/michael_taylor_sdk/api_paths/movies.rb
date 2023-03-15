# frozen_string_literal: true

require_relative("base")

require "michael_taylor_sdk/pipeline/set_path"
require "michael_taylor_sdk/constants"

module MichaelTaylorSdk::ApiPaths
  ##
  # Queries related to /movie
  class Movies < Base
    include MichaelTaylorSdk::Constants
    def path
      MOVIE_PATH
    end
  end
end
