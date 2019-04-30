require 'funny_guy/services/markov'
require 'strscan'
require 'json'
require 'yaml'

class FunnyGuy::Services::Markov::Processor
  include FunnyGuy::Services::Markov

  attr_reader :chain

  def initialize(order: 1)
    ensure_order! order
    @order = order
    @chain = { END_TOKEN => [] }
  end

  def process(text)
    text.delete!("\n")
    text.strip!
    @buffer = StringScanner.new(text)
    until @buffer.eos?
      str = @buffer.scan_until SUPPORTED_PUNCTUATION
      str.gsub!(/[,:;]/, '')
      words = str.strip.split(/\s+/)
      lw = [*init_vector, *words].each_cons(@order + 1).inject(nil) do |last_word, slice|
        *key, word = slice
        @chain[key] ||= {}
        @chain[key][word] ||= 0
        @chain[key][word] += 1
        word
      end
      @chain[END_TOKEN] |= [lw]
    end
  end

  def to_chain
    FunnyGuy::Services::Markov::Chain.new @chain, order: @order
  end
end
