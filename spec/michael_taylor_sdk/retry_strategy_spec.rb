# frozen_string_literal: true

require "json"
require "michael_taylor_sdk/retry_strategy/exponential_backoff"

RSpec.describe MichaelTaylorSdk::RetryStrategy do
  def setup_tests_and_response(expected_path)
    http = instance_double(Net::HTTP)
    allow(Net::HTTP).to receive(:start).with("the-one-api.dev", { use_ssl: true }).and_yield(http)
    allow(http).to receive(:request) do |request|
      expect(request.uri.request_uri).to eq "/v2/#{expected_path}"

      response = instance_double(Net::HTTPInternalServerError)
      allow(response).to receive_messages(class: Net::HTTPInternalServerError, code: "500",
                                          message: "Internal Server Error")
      allow(response).to receive(:is_a?).with(Net::HTTPServerError).and_return(true)
      allow(response).to receive(:is_a?).with(Net::HTTPClientError).and_return(false)
      response
    end
  end

  it "only tries once by default" do
    setup_tests_and_response("movie")
    movies_api = MichaelTaylorSdk::LordOfTheRings.new("").movies
    expect { movies_api.list }.to raise_error(MichaelTaylorSdk::Errors::ServerError)
  end

  it "can try more than once" do
    setup_tests_and_response("movie")

    exponential_backoff = MichaelTaylorSdk::RetryStrategy::ExponentialBackoff.new(3)
    allow(exponential_backoff).to receive(:sleep)

    movies_api = MichaelTaylorSdk::LordOfTheRings.new("").with_retry_strategy(exponential_backoff).movies
    expect { movies_api.list }.to raise_error(MichaelTaylorSdk::Errors::ServerError)

    expect(exponential_backoff).to have_received(:sleep).exactly(2).times
    expect(exponential_backoff).to have_received(:sleep) do |sleep_time|
      expect(sleep_time).to be >= 0.05
      expect(sleep_time).to be <= 0.1
    end
    expect(exponential_backoff).to have_received(:sleep) do |sleep_time|
      expect(sleep_time).to be >= 0.1
      expect(sleep_time).to be <= 0.2
    end
  end
end
