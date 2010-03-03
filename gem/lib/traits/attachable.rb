# An Attachable can be attached to a Pod.
#
module Attachable
  
  attr_accessor :relative_position
  
  def move_relative pod
    self.position = pod.position + relative_position # pod.rotation
    self.rotation = pod.rotation
  end
  
end