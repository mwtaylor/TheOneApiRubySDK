# frozen_string_literal: true

require "json"
require "michael_taylor_sdk/retry_strategy/exponential_backoff"

RSpec.describe MichaelTaylorSdk::ApiPaths::Movies do
  def setup_tests_and_response(expected_path)
    http = double(Net::HTTP)
    allow(Net::HTTP).to receive(:start).with("the-one-api.dev", { use_ssl: true }).and_yield(http)
    allow(http).to receive(:request) do |request|
      expect(request.uri.request_uri).to eq "/v2/#{expected_path}"

      response = double(Net::HTTPInternalServerError)
      allow(response).to receive(:class).and_return(Net::HTTPInternalServerError)
      allow(response).to receive(:code).and_return("500")
      allow(response).to receive(:message).and_return("Internal Server Error")
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
    expect(exponential_backoff).to(receive(:sleep).once do |sleep_time|
      expect(sleep_time).to be >= 0.05
      expect(sleep_time).to be <= 0.1
    end)
    expect(exponential_backoff).to(receive(:sleep).once do |sleep_time|
      expect(sleep_time).to be >= 0.1
      expect(sleep_time).to be <= 0.2
    end)

    movies_api = MichaelTaylorSdk::LordOfTheRings.new("").with_retry_strategy(exponential_backoff).movies
    expect { movies_api.list }.to raise_error(MichaelTaylorSdk::Errors::ServerError)
  end
end
