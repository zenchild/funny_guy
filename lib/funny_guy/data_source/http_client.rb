require 'funny_guy/data_source'
require 'faraday'
require 'faraday_middleware'

require 'forwardable'

class FunnyGuy::DataSource::HttpClient
  extend Forwardable

  def_delegators :http, *Faraday::Connection::METHODS

  attr_reader :http

  def initialize(api_host:, **opts)
    raise FunnyGuy::ArgumentError, "api_host cannot be nil" if api_host.nil?

    api_uri = api_host.instance_of?(String) ? URI.parse(api_host) : api_host
    adapter = opts.delete(:adapter) || default_adapter
    adapter = adapter.is_a?(Array) ? adapter : [adapter]
    @http = initialize_connection(api_uri, **opts) do |c|
      yield c if block_given?
      c.headers.merge! headers
      c.adapter(*adapter)
    end
  end

  private

  def default_adapter
    Faraday.default_adapter
  end

  def headers
    {
      'User-Agent'   => "Funny Guy Client #{FunnyGuy::VERSION}",
      'Content-Type' => 'application/json'
    }
  end

  def initialize_connection(url, **opts)
    Faraday.new(url: url, **opts) do |c|
      # -- request --
      c.request :multipart
      c.request :json

      # -- response --
      c.response :funny_guy_data_source_error_handler
      c.response :mashify
      c.response :json, content_type: /\bjson/

      yield c if block_given?
    end
  end
end
