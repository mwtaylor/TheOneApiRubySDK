# frozen_string_literal: true

require "elephant_in_the_room/the_one_api_sdk/api_paths/books"
require "elephant_in_the_room/the_one_api_sdk/api_paths/movies"
require "elephant_in_the_room/the_one_api_sdk/api_paths/characters"
require "elephant_in_the_room/the_one_api_sdk/api_paths/quotes"
require "elephant_in_the_room/the_one_api_sdk/api_paths/chapters"

module ElephantInTheRoom::TheOneApiSdk::ApiPaths
  ##
  # Mixin to add all available API paths to the parent object
  module AllPaths
    ##
    # Provides queries related to books
    def books
      ElephantInTheRoom::TheOneApiSdk::ApiPaths::Books.new(@pipeline)
    end

    ##
    # Provides queries related to movies
    def movies
      ElephantInTheRoom::TheOneApiSdk::ApiPaths::Movies.new(@pipeline)
    end

    ##
    # Provides queries related to characters
    def characters
      ElephantInTheRoom::TheOneApiSdk::ApiPaths::Characters.new(@pipeline)
    end

    ##
    # Provides queries related to quotes
    def quotes
      ElephantInTheRoom::TheOneApiSdk::ApiPaths::Quotes.new(@pipeline)
    end

    ##
    # Provides queries related to chapters
    def chapters
      ElephantInTheRoom::TheOneApiSdk::ApiPaths::Chapters.new(@pipeline)
    end
  end
end
