# frozen_string_literal: true

module MichaelTaylorSdk::RetryStrategy
  class OneTry
    def run(do_request)
      do_request.call
    end
  end
end
