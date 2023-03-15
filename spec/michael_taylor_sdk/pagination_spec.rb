# frozen_string_literal: true

require "json"

RSpec.describe MichaelTaylorSdk::Pipeline::Paginate do
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

  it "defaults to no pagination" do
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
      total: 2,
      limit: 1000,
      offset: 0,
      page: 1,
      pages: 1,
    }
    setup_tests_and_response("movie", response_body.to_json)
    movies_api = MichaelTaylorSdk::LordOfTheRings.new("").movies
    movies_list = movies_api.list
    expect(movies_list).to include(:items, :pagination)
    expect(movies_list[:items].length).to eq 2
    expect(movies_list[:pagination][:total]).to eq 2
  end

  it "accepts custom pagination" do
    response_body = {
      docs: [
        {
          _id: "1",
          name: "movie one",
        },
      ],
      total: 1,
      limit: 1000,
      offset: 0,
      page: 1,
      pages: 1,
    }
    setup_tests_and_response("movie?limit=1", response_body.to_json)
    movies_api = MichaelTaylorSdk::LordOfTheRings.new("").paginated(limit: 1).movies
    movies_list = movies_api.list
    expect(movies_list).to include(:items, :pagination)
    expect(movies_list[:items].length).to eq 1
    expect(movies_list[:pagination][:total]).to eq 1
  end
end
