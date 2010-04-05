# Use this for a thing that damages.
#
# Example:
#   class Rocket
#     it_is Damaging
#
#     damage { rand(10) + 5 }
#   end
#   
#   OR
#   class Rocket
#     it_is Damaging
#
#     damage 15
#   end
#   
#   OR
#   
#   class Rocket
#     it_is Damaging
#
#     def damage
#       # Define your own damage method.
#     end
#   end
#
module Damaging
  
  # TODO Explain better what to do.
  #
  class DamageMissingError < StandardError; end
  
  def self.included klass
    klass.extend ClassMethods
  end
  
  def initialize window
    raise DamageMissingError.new unless self.respond_to? :damage
    super window
  end
  
  module ClassMethods
    
    def damage damage = nil, &block
      block = lambda { damage } unless block_given?
      define_method :damage, &block
    end
    
  end
  
end