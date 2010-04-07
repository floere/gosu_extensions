#
#
class Controls
  
  #
  #
  def initialize
    @controls = []
  end
  
  # Add the given control to the controls, except if it is nil or has no mapping.
  #
  def << control
    return unless control && control.mapping?
    @controls << control
  end
  
  # Remove the control(s) with the given controllable.
  #
  def remove_all_of controllable
    @controls.reject { |control| control.controllable == controllable }
  end
  
  # 
  #
  def handle
    @controls.each &:handle
  end
  
end