# frozen_string_literal: true

require "json"

RSpec.describe MichaelTaylorSdk::ModifiedSdk do
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

  it "can chain modifiers" do
    setup_tests_and_response("movie?limit=1")
    exponential_backoff = MichaelTaylorSdk::RetryStrategy::ExponentialBackoff.new(2)
    allow(exponential_backoff).to receive(:sleep)
    sdk = MichaelTaylorSdk::LordOfTheRings.new("")
    sdk.with_retry_strategy(exponential_backoff).paginated(limit: 1) do |modified_sdk|
      expect do
        modified_sdk.movies.list
      end.to raise_error(MichaelTaylorSdk::Errors::ServerError, "(Server Error) 500: Internal Server Error")
    end
    expect(exponential_backoff).to have_received(:sleep).once do |sleep_time|
      expect(sleep_time).to be >= 0.05
      expect(sleep_time).to be <= 0.1
    end
  end
end
