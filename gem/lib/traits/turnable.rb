module Turnable
  
  # TODO expose a class method which exposes the prototypical turn speed.
  #
  
  # 
  #
  attr_accessor :turn_speed
  
  # Turns the thing left, depending on turn speed.
  #
  def turn_left
    self.rotation -= self.turn_speed / SUBSTEPS
  end
  
  # Turns the thing right, depending on turn speed.
  #
  def turn_right
    self.rotation += self.turn_speed / SUBSTEPS
  end
  
end