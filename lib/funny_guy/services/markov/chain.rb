require 'funny_guy/services/markov'
require 'securerandom'

class FunnyGuy::Services::Markov::Chain
  include FunnyGuy::Services::Markov

  def self.load_chain(file_path:, order:)
    chain = Marshal.load(File.read(file_path))
    new(chain, order: order)
  end

  attr_reader :order, :chain

  def initialize(chain, order: 1)
    ensure_order! order
    @order = order
    @chain = chain
  end

  def finished?(key)
    chain[END_TOKEN].include? key
  end

  def select(key)
    total = @chain[key].values.inject(:+)
    accum = 0
    selection = @chain[key].each_with_object({}) do |(k, v), selection|
      accum += (v.to_f / total).round(3)
      selection[k] = accum
    end
    r = SecureRandom.random_number(1.0)
    selection.find { |k, v| v > r }&.first
  end
end
