# frozen_string_literal: true

require "json"

RSpec.describe MichaelTaylorSdk::ApiPaths::Movies do
  def setup_tests_and_response(body)
    http = instance_double(Net::HTTP)
    allow(Net::HTTP).to receive(:start).with("the-one-api.dev", { use_ssl: true }).and_yield(http)
    allow(http).to receive(:request) do
      response = instance_double(Net::HTTPOK)
      allow(response).to receive(:is_a?).with(Net::HTTPServerError).and_return(false)
      allow(response).to receive(:is_a?).with(Net::HTTPClientError).and_return(false)
      allow(response).to receive_messages(class: Net::HTTPOK, code: "200", body: body)
      response
    end
  end

  it "lists all movies" do
    response_body = {
      docs: [
        {
          _id: "1",
          name: "movie one",
        },
        {
          _id: "2",
          name: "movie two",
        },
      ],
    }
    setup_tests_and_response(response_body.to_json)
    movies_api = MichaelTaylorSdk::LordOfTheRings.new("").movies
    movies_list = movies_api.list
    expect(movies_list).to include(:items)
    expect(movies_list[:items].length).to eq 2
  end

  it "gets one movie by ID" do
    response_body = {
      docs: [
        {
          _id: "1",
          name: "movie one",
        },
      ],
    }
    setup_tests_and_response(response_body.to_json)
    movies_api = MichaelTaylorSdk::LordOfTheRings.new("").movies
    movies_list = movies_api.get("1")
    expect(movies_list).to include(:items)
    expect(movies_list[:items].length).to eq 1
  end
end
