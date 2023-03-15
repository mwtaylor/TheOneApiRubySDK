RSpec.describe MichaelTaylorSdk::ApiPaths::Movies do
  def setup_tests_and_response(expected_path, body)
    http = double(Net::HTTP)
    expect(Net::HTTP).to receive(:start).with("the-one-api.dev", { use_ssl: true }).and_yield(http)
    expect(http).to receive(:request) do |request|
      expect(request.uri.request_uri).to eq "/v2/#{expected_path}"

      response = double(Net::HTTPOK)
      allow(response).to receive(:body).and_return(body)
      response
    end
  end

  it "lists all movies" do
    setup_tests_and_response("movie", "{}")
    movies_api = MichaelTaylorSdk::LordOfTheRings.new("").movies
    movies_api.list
  end
end