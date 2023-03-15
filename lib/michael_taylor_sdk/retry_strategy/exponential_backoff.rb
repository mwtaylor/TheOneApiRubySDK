# frozen_string_literal: true

require "michael_taylor_sdk/constants"

module MichaelTaylorSdk::RetryStrategy
  ##
  # Retry strategy for exponential backoffs
  #
  # This will rerun an HTTP call up to max_tries times. Each retry will be delayed.
  # The delay will have an exponential backoff that makes each delay about twice as long as the previous delay.
  # The delay will also have a random jitter added to avoid overloading the server from many clients
  # retrying simultaneously.
  class ExponentialBackoff
    include MichaelTaylorSdk::Constants

    def initialize(max_tries)
      @max_tries = max_tries
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

    private

    def jittered_sleep(tries)
      max_sleep_seconds = Float(2**tries) / EXPONENTIAL_BACKOFF_TIME_DIVISOR
      sleep(rand((0.5 * max_sleep_seconds)..max_sleep_seconds))
    end
  end
end
