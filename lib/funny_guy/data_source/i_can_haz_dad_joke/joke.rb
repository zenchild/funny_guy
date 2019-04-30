require 'funny_guy/data_source/i_can_haz_dad_joke'

class FunnyGuy::DataSource::ICanHasDadJoke::Joke
  extend Forwardable

  def initialize(object)
    @object = object
  end

  def_delegators :@object, :id, :status, :joke
  def_delegator :@object, :joke, :to_s

  def as_json
    @object
  end
end
