require 'funny_guy/data_source'

module FunnyGuy::DataSource
  module Middleware
    module Response
      class ErrorHandler < ::Faraday::Response::Middleware
        def on_complete(env)
          case env[:status]
          when 500 # InternalServerError
            raise FunnyGuy::HTTPError::InternalServerError, response_values(env)
          when 404 # NotFound
            raise FunnyGuy::HTTPError::NotFound, response_values(env)
          when 401 # Unauthorized
            raise FunnyGuy::HTTPError::Unauthorized, response_values(env)
          when 400 # BadRequest
            raise FunnyGuy::HTTPError::BadRequest, response_values(env)
          when 400...600 # UnknownError
            raise FunnyGuy::HTTPError::UnknownError, response_values(env)
          end
        end

        def response_values(env)
          {
            url:              env.url,
            status:           env.status,
            request_headers:  env.request_headers,
            response_headers: env.response_headers,
            body:             env.body
          }
        end
      end
    end
  end
end

Faraday::Response.register_middleware funny_guy_data_source_error_handler: FunnyGuy::DataSource::Middleware::Response::ErrorHandler
