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
module Damaging extend Trait
  
  class DamageMissingError < RuntimeError
    def initialize
      super <<-MESSAGE
        
        In a Damaging thing, you need to define method
          damage damage = nil, &block
        with params
          damage 13 # some value
        or
          damage { 13 + rand(7) } # some block
        to define how much damage the thing does.
        
      MESSAGE
    end
  end
  
  def self.included klass
    klass.extend ClassMethods
  end
  
  def initialize window
    raise DamageMissingError.new unless respond_to?(:damage)
    super window
  end
  
  module ClassMethods
    
    def damage damage = nil, &block
      block = lambda { damage } unless block_given?
      define_method :damage, &block
    end
    
  end
  
end