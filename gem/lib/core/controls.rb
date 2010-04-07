#
#
class Controls
  
  attr_reader :controls
  
  # It's possible to give the controls a number of controls.
  #
  def initialize *controls
    @controls = controls
  end
  
  # Add the given control to the controls, except if it is nil or has no mapping.
  #
  def << control
    return unless control && control.mapping?
    @controls << control
    @controls
  end
  
  # Remove the control(s) with the given controllable.
  #
  def remove_all_of controllable
    @controls.reject! { |control| control.controllable == controllable }
  end
  
  # Let each control handle input.
  #
  def handle
    @controls.each &:handle
  end
  
end