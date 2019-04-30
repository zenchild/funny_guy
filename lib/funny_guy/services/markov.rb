require 'funny_guy/services'

module FunnyGuy::Services::Markov
  SUPPORTED_PUNCTUATION = /[.?!]?$/.freeze
  START_TOKEN = "__begin__".freeze
  END_TOKEN = "__end__".freeze
  MAX_ORDER = 3

  def init_vector
    @init_vector ||= ([START_TOKEN] * @order)
  end

  private

  def ensure_order!(order)
    unless order.between?(1, MAX_ORDER)
      raise StandardError, "You have specified an order that is not supported (#{order})."
    end
  end
end
