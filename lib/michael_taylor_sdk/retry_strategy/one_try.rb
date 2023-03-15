# frozen_string_literal: true

module MichaelTaylorSdk::RetryStrategy
  ##
  # The default retry strategy that just runs a request once and passes along any errors
  class OneTry
    def run(do_request)
      do_request.call
    end
  end
end
