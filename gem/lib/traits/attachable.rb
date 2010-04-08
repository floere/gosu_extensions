# An Attachable can be attached to a Pod.
#
module Attachable extend Trait
  
  attr_accessor :relative_position
  
  def move_relative pod
    self.position = pod.relative_position self
    self.rotation = pod.rotation
  end
  
end