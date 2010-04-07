#
#
class Control
  
  #
  #
  def initialize window, controllable, mapping = nil
    @window = window
    @controllable = controllable
    @mapping = mapping || controllable.controls_mapping
  end
  
  #
  #
  def mapping?
    !@mapping.nil? && !@mapping.empty?
  end
  
  # 
  #
  def handle
    return if @controllable.destroyed?
    @mapping.each do |key, command|
      @controllable.send(command) if @window.button_down? key
    end
  end
  
end