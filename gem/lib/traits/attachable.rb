# An Attachable can be attached to a Pod.
#
module Attachable extend Trait
  
  Detach = :detach
  
  attr_accessor :relative_position, :relative_rotation, :pod
  
  def detach
    pod.detach self
  end
  
  # Callback after detachment.
  #
  def detached; end
  #
  # after attachment
  #
  def attached
    self.relative_rotation = pod.rotation + self.rotation
  end
  
  # Move relative to the pod.
  #
  def move_relative
    self.position = pod.relative_position self
    self.rotation = pod.relative_rotation self unless self.kind_of? Turnable
  end
  
end