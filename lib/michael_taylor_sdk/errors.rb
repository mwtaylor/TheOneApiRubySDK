# frozen_string_literal: true

module MichaelTaylorSdk::Errors
  ##
  # Errors related to HTTP response codes
  class HttpError < StandardError
    def initialize(message_prefix, response)
      super("(#{message_prefix}) #{response.code}: #{response.message}")
    end
  end

  ##
  # Errors in the HTTP 5XX range
  class ServerError < HttpError
    def initialize(response)
      super("Server Error", response)
    end
  end

  ##
  # Errors in the HTTP 4XX range
  class ClientError < HttpError
    def initialize(response)
      super("Client Error", response)
    end
  end

  ##
  # Errors related to processing the returned content
  class ContentError < StandardError
    def initialize(msg = nil)
      super
    end
  end

  ##
  # Error caused by a JSON parser error
  class JsonParseError < ContentError
  end

  ##
  # Error caused by no content being returned by the server
  class NoContentError < ContentError
  end
end
