# frozen_string_literal: true

require_relative("base")

require "michael_taylor_sdk/pipeline/set_path"

module MichaelTaylorSdk::ApiPaths
  ##
  # Queries related to /movie
  class Movies < Base
    def path
      "movie"
    end
  end
end
