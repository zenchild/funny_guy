module FunnyGuy
  class Error < ::StandardError; end
  class ArgumentError < Error; end

  module HTTPError
    class ClientError < ::Faraday::Error::ClientError; end
    class NotFound < ClientError; end
    class Unauthorized < ClientError; end
    class BadRequest < ClientError; end
    class InternalServerError < ClientError; end
    class UnknownError < ClientError; end
  end
end
