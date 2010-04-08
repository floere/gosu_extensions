# An Attachable can be attached to a Pod.
#
module Attachable extend Trait
  
  attr_accessor :relative_position
  
  def move_relative pod
    self.position = pod.position + self.relative_position.rotate(pod.rotation_vector)
    self.rotation = pod.rotation
  end
  
end