# frozen_string_literal: true

require "json"

RSpec.describe ElephantInTheRoom::TheOneApiSdk::Errors do
  context "with HTTP errors" do
    def setup_tests_and_response(expected_path, response)
      http = instance_double(Net::HTTP)
      allow(Net::HTTP).to receive(:start).with("the-one-api.dev", { use_ssl: true }).and_yield(http)
      allow(http).to receive(:request) do |request|
        expect(request.uri.request_uri).to eq "/v2/#{expected_path}"

        response
      end
    end

    it "raises a readable server error" do
      response = instance_double(Net::HTTPInternalServerError)
      allow(response).to receive_messages(class: Net::HTTPInternalServerError, code: "500",
                                          message: "Internal Server Error")
      allow(response).to receive(:is_a?).with(Net::HTTPServerError).and_return(true)
      allow(response).to receive(:is_a?).with(Net::HTTPClientError).and_return(false)

      setup_tests_and_response("movie", response)
      movies_api = ElephantInTheRoom::TheOneApiSdk::TheOne.new("").movies
      expect do
        movies_api.list
      end.to raise_error(ElephantInTheRoom::TheOneApiSdk::Errors::ServerError,
                         "(Server Error) 500: Internal Server Error")
    end

    it "raises a readable client error" do
      response = instance_double(Net::HTTPNotFound)
      allow(response).to receive_messages(class: Net::HTTPNotFound, code: "404", message: "Not Found")
      allow(response).to receive(:is_a?).with(Net::HTTPServerError).and_return(false)
      allow(response).to receive(:is_a?).with(Net::HTTPClientError).and_return(true)

      setup_tests_and_response("movie", response)
      movies_api = ElephantInTheRoom::TheOneApiSdk::TheOne.new("").movies
      expect do
        movies_api.list
      end.to raise_error(ElephantInTheRoom::TheOneApiSdk::Errors::ClientError, "(Client Error) 404: Not Found")
    end
  end

  context "with content errors" do
    let(:http) { instance_double(Net::HTTP) }

    def setup_tests_and_response(body)
      allow(Net::HTTP).to receive(:start).with("the-one-api.dev", { use_ssl: true }).and_yield(http)
      allow(http).to receive(:request) do
        response = instance_double(Net::HTTPOK)
        allow(response).to receive(:is_a?).with(Net::HTTPServerError).and_return(false)
        allow(response).to receive(:is_a?).with(Net::HTTPClientError).and_return(false)
        allow(response).to receive_messages(class: Net::HTTPOK, code: "200", body: body)
        response
      end
    end

    def check_expectations(expected_path)
      expect(Net::HTTP).to have_received(:start).with("the-one-api.dev", { use_ssl: true })
      expect(http).to have_received(:request) do |request|
        expect(request.uri.request_uri).to eq "/v2/#{expected_path}"
      end
    end

    it "raises an error for unparseable JSON" do
      response_body = "{[}]"
      setup_tests_and_response(response_body)
      movies_api = ElephantInTheRoom::TheOneApiSdk::TheOne.new("").movies
      expect do
        movies_api.list
      end.to raise_error(ElephantInTheRoom::TheOneApiSdk::Errors::JsonParseError,
                         "JSON response could not be parsed: expected object key, got '[}]")
      check_expectations("movie")
    end

    it "raises an error for no content" do
      setup_tests_and_response("")
      movies_api = ElephantInTheRoom::TheOneApiSdk::TheOne.new("").movies
      expect do
        movies_api.list
      end.to raise_error(ElephantInTheRoom::TheOneApiSdk::Errors::NoContentError, "Server response was empty")
      check_expectations("movie")
    end
  end
end
