# frozen_string_literal: true

require "json"

RSpec.describe MichaelTaylorSdk::ApiPaths::Movies do
  context "HTTP Errors" do
    def setup_tests_and_response(expected_path, response)
      http = double(Net::HTTP)
      allow(Net::HTTP).to receive(:start).with("the-one-api.dev", { use_ssl: true }).and_yield(http)
      allow(http).to receive(:request) do |request|
        expect(request.uri.request_uri).to eq "/v2/#{expected_path}"

        response
      end
    end

    it "raises a readable server error" do
      response = double(Net::HTTPInternalServerError)
      allow(response).to receive(:class).and_return(Net::HTTPInternalServerError)
      allow(response).to receive(:code).and_return("500")
      allow(response).to receive(:message).and_return("Internal Server Error")
      allow(response).to receive(:is_a?).with(Net::HTTPServerError).and_return(true)
      allow(response).to receive(:is_a?).with(Net::HTTPClientError).and_return(false)

      setup_tests_and_response("movie", response)
      movies_api = MichaelTaylorSdk::LordOfTheRings.new("").movies
      expect { movies_api.list }.to raise_error(MichaelTaylorSdk::Errors::ServerError, "(Server Error) 500: Internal Server Error")
    end

    it "raises a readable client error" do
      response = double(Net::HTTPNotFound)
      allow(response).to receive(:class).and_return(Net::HTTPNotFound)
      allow(response).to receive(:code).and_return("404")
      allow(response).to receive(:message).and_return("Not Found")
      allow(response).to receive(:is_a?).with(Net::HTTPServerError).and_return(false)
      allow(response).to receive(:is_a?).with(Net::HTTPClientError).and_return(true)

      setup_tests_and_response("movie", response)
      movies_api = MichaelTaylorSdk::LordOfTheRings.new("").movies
      expect { movies_api.list }.to raise_error(MichaelTaylorSdk::Errors::ClientError, "(Client Error) 404: Not Found")
    end
  end

  context "Content Errors" do
    def setup_tests_and_response(expected_path, body)
      http = double(Net::HTTP)
      expect(Net::HTTP).to receive(:start).with("the-one-api.dev", { use_ssl: true }).and_yield(http)
      expect(http).to receive(:request) do |request|
        expect(request.uri.request_uri).to eq "/v2/#{expected_path}"

        response = double(Net::HTTPOK)
        allow(response).to receive(:class).and_return(Net::HTTPOK)
        allow(response).to receive(:code).and_return("200")
        allow(response).to receive(:is_a?).with(Net::HTTPServerError).and_return(false)
        allow(response).to receive(:is_a?).with(Net::HTTPClientError).and_return(false)
        allow(response).to receive(:body).and_return(body)
        response
      end
    end

    it "raises an error for unparseable JSON" do
      response_body = "{[}]"
      setup_tests_and_response("movie", response_body)
      movies_api = MichaelTaylorSdk::LordOfTheRings.new("").movies
      expect { movies_api.list }.to raise_error(MichaelTaylorSdk::Errors::JsonParseError, "JSON response could not be parsed: unexpected token at '{[}]'")
    end

    it "raises an error for no content" do
      setup_tests_and_response("movie", "")
      movies_api = MichaelTaylorSdk::LordOfTheRings.new("").movies
      expect { movies_api.list }.to raise_error(MichaelTaylorSdk::Errors::NoContentError, "Server response was empty")
    end
  end
end
