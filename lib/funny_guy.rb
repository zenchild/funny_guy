require "funny_guy/version"
require "faraday"
require "faraday_middleware"

module FunnyGuy
  class Generator
    def self.gemdir
      File.expand_path("#{__dir__}/../")
    end

    def self.dbdir
      "#{gemdir}/db"
    end

    def self.jokesdb
      "#{gemdir}/db/jokes.txt"
    end

    def self.markovdb(order)
      "#{gemdir}/db/markov-order-#{order}.db"
    end

    def self.build_jokes_db!
      apisvc = FunnyGuy::DataSource::ICanHasDadJoke.new
      File.open(jokesdb, "w") do |f|
        apisvc.search_jokes(limit: 100).each do |joke|
          str = joke.to_s.gsub(/[\n\r]+/, " ")
          f.puts str.strip
        end
      end
    end

    def self.ensure_jokes_db!
      unless File.exist?(jokesdb)
        Dir.mkdir dbdir unless Dir.exist?(dbdir)
        build_jokes_db!
      end
    end

    def self.ensure_markov!(order)
      unless File.exist?(markovdb(order))
        Dir.mkdir dbdir unless Dir.exist?(dbdir)
        build_markov_chain order
      end
    end

    def self.build_markov_chain(order)
      ensure_jokes_db!
      g = FunnyGuy::Services::Markov::Processor.new(order: order)
      File.open(jokesdb, "r") do |f|
        f.each do |line|
          g.process line.chomp
        end
      end
      File.open(markovdb(order), "w") do |f|
        f.write Marshal.dump g.chain
      end
    end

    def self.tell_me_a_joke(order)
      ensure_markov! order
      g = FunnyGuy::Services::Markov::Chain.load_chain file_path: markovdb(order), order: order
      new(g).tell_me_a_joke
    end

    attr_reader :chain

    def initialize(chain)
      @chain = chain
      @key = chain.init_vector
    end

    def tell_me_a_joke
      [].tap do |joke|
        until chain.finished?(@key.last)
          word = chain.select(@key)
          @key.shift
          @key.push word
          joke << word
        end
      end.join(" ")
    end
  end
end

require "funny_guy/errors"
require "funny_guy/data_source"
require "funny_guy/data_source/http_client"
require "funny_guy/data_source/middleware/response/error_handler"
require "funny_guy/data_source/i_can_haz_dad_joke"
require "funny_guy/services/markov"
require "funny_guy/services/markov/processor"
require "funny_guy/services/markov/chain"
