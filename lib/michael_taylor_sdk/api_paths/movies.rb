# frozen_string_literal: true

require_relative("base")

require "michael_taylor_sdk/pipeline/set_path"
require "michael_taylor_sdk/constants"

module MichaelTaylorSdk::ApiPaths
  ##
  # Queries related to /movie
  class Movies < Base
    include MichaelTaylorSdk::Constants

    ##
    # Find all quotes for a given movie
    def quotes_from_movie(id)
      with_path(@pipeline, quote_path(id)) do |pipeline|
        execute_pipeline(pipeline, {})
      end
    end

    ##
    # Lookup a movie by name and get all quotes from it
    def quotes_from_movie_name(name)
      movies = with_filters(@pipeline, ["name=#{name}"]) do |filtered_pipeline|
        with_pagination(filtered_pipeline, limit: 1) do |paginated_pipeline|
          execute_pipeline(paginated_pipeline, {})
        end
      end
      raise "Movie named #{name} not found" if movies[:items].empty?

      matching_movie = movies[:items][0]
      quotes_from_movie(matching_movie[:_id])
    end

    protected

    def path
      MOVIE_PATH
    end

    def quote_path(id)
      "#{MOVIE_PATH}/#{id}/#{QUOTE_PATH}"
    end
  end
end
