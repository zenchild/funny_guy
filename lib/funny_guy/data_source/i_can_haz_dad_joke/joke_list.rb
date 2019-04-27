require 'funny_guy/data_source/i_can_haz_dad_joke'
require 'funny_guy/data_source/i_can_haz_dad_joke/joke'

class FunnyGuy::DataSource::ICanHasDadJoke::JokeList
  extend Forwardable
  include Enumerable

  attr_reader :object

  def initialize(object, client)
    @object = object
    @client = client
    @pages = []
  end

  def_delegators :@object, :limit, :next_page, :total_pages, :search_term, :total_jokes, :status
  def_delegator :@object, :current_page, :page

  def page_jokes
    @page_jokes ||= @object.results.collect do |joke|
      FunnyGuy::DataSource::ICanHasDadJoke::Joke.new joke
    end
  end

  def each_page(&block)
    return to_enum(__method__) unless block_given?
    if @pages.empty?
      @pages << page_jokes
      yield page_jokes
      until last_page?
        get_next_page!
        @pages << page_jokes
        yield page_jokes
      end
    else
      @pages.each do |page|
        yield page
      end
    end
  end

  def each(&block)
    return to_enum(__method__) unless block_given?

    each_page do |jokes|
      jokes.each { |j| yield j }
    end
  end

  def get_next_page!
    if last_page?
      raise FunnyGuy::Error, "There is no last page to fetch."
    end

    tap do
      resp = @client.raw_search_jokes(term: search_term, limit: limit, page: next_page)
      @object = resp.body
      @page_jokes = nil
    end
  end

  def last_page?
    page == total_pages
  end
end
