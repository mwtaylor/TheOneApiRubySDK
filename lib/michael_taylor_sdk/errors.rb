# frozen_string_literal: true

module MichaelTaylorSdk::Errors
  class HttpError < StandardError
    def initialize(message_prefix, response)
      super("(#{message_prefix}) #{response.code}: #{response.message}")
    end
  end

  class ServerError < HttpError
    def initialize(response)
      super("Server Error", response)
    end
  end

  class ClientError < HttpError
    def initialize(response)
      super("Client Error", response)
    end
  end

  class ContentError < StandardError
    def initialize(msg = nil)
      super(msg)
    end
  end

  class JsonParseError < ContentError
  end

  class NoContentError < ContentError
  end
end
