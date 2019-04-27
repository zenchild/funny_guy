require 'funny_guy/data_source'
require 'funny_guy/data_source/http_client'

class FunnyGuy::DataSource::ICanHasDadJoke
  ENDPOINT = "https://icanhazdadjoke.com".freeze

  attr_reader :http

  def initialize(**connection_args)
    @http = FunnyGuy::DataSource::HttpClient.new(api_host: ENDPOINT, **connection_args) do |c|
      c.headers.merge!({ 'Accept' => 'application/json' })
    end
  end

  # Get a joke from the API by id. If the id is nil it will return a random joke
  # @see https://icanhazdadjoke.com/api#fetch-a-dad-joke
  # @param String [id] The id of a joke to fetch from the ICanHazDadJoke API
  # @return [Hashie::Mash] The joke object
  def joke(id)
    path = id.nil? ? "/" : "/j/#{id}"
    resp = http.get(path).tap do |resp|
      if resp.body.status == 404
        raise FunnyGuy::HTTPError::NotFound, error_handler.response_values(resp.env)
      end
    end
    FunnyGuy::DataSource::ICanHasDadJoke::Joke.new resp.body
  end

  # Get Get a random joke
  # @see https://icanhazdadjoke.com/api#fetch-a-random-dad-joke
  # @see #joke
  def random_joke
    joke nil
  end

  def search_jokes(**params)
    resp = raw_search_jokes(**params)
    FunnyGuy::DataSource::ICanHasDadJoke::JokeList.new resp.body, self
  end

  # @see https://icanhazdadjoke.com/api#search-for-dad-jokes
  def raw_search_jokes(term: nil, limit: 30, page: 1)
    http.get("/search", {term: term, limit: limit, page: page})
  end

  private

  def ensure_id!(id)
    raise FunnyGuy::ArgumentError, "id cannot be NULL" if id.nil?
  end

  def error_handler
    FunnyGuy::DataSource::Middleware::Response::ErrorHandler.new
  end
end

require 'funny_guy/data_source/i_can_haz_dad_joke/joke'
require 'funny_guy/data_source/i_can_haz_dad_joke/joke_list'
