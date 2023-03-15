# frozen_string_literal: true

module MichaelTaylorSdk::RetryStrategy
  class ExponentialBackoff
    def initialize(max_tries)
      @max_tries = max_tries
    end

    def jittered_sleep(tries)
      max_sleep_seconds = Float(2**tries) / 20
      sleep(rand((0.5 * max_sleep_seconds)..max_sleep_seconds))
    end

    def run(do_request)
      tries = 0
      begin
        tries += 1
        do_request.call
      rescue MichaelTaylorSdk::Errors::ServerError
        raise if tries == @max_tries

        jittered_sleep(tries)

        retry
      end
    end
  end
end
