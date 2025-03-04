# frozen_string_literal: true

require_relative("base")

require "elephant_in_the_room/the_one_api_sdk/pipeline/set_path"
require "elephant_in_the_room/the_one_api_sdk/constants"

module ElephantInTheRoom::TheOneApiSdk::ApiPaths
  ##
  # Queries related to /movie
  class Books < Base
    include ElephantInTheRoom::TheOneApiSdk::Constants

    protected

    def path
      BOOK_PATH
    end
  end
end
