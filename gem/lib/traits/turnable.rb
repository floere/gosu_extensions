#
#
module Turnable
  
  Left  = :turn_left
  Right = :turn_right
  
  def self.included base
    base.extend ClassMethods
  end
  
  # TODO meta
  #
  module ClassMethods
    def turn_speed amount
      define_method :turn_speed do
        amount
      end
    end
  end
  
  #
  #
  def turn_speed
    0.5 # Default turn speed
  end
  
  # Turns the thing left, depending on turn speed.
  #
  def turn_left
    self.rotation -= self.turn_speed / (SUBSTEPS**2)
  end
  
  # Turns the thing right, depending on turn speed.
  #
  def turn_right
    self.rotation += self.turn_speed / (SUBSTEPS**2)
  end
  
end