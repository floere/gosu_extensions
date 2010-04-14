# An Attachable can be attached to a Pod.
#
module Attachable extend Trait
  
  Detach = :detach
  
  attr_accessor :relative_position, :pod
  
  def detach
    pod.detach self
  end
  
  # Callback after detachment.
  #
  def detached; end
  
  # Move relative to the pod.
  #
  def move_relative
    self.position = pod.relative_position self
    self.rotation = pod.rotation unless self.kind_of? Turnable
  end
  
end