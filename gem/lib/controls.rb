# Controls for a controllable.
#
class Controls
  
  def initialize window, controllable, mapping = {}
    @window = window
    @controllable = controllable
    @mapping = mapping
  end
  
  # Gosu::Button::KbLeft => :turn_left
  #
  def configure mapping
    @mapping = mapping
  end
  
  def handle
    @mapping.each do |key, command|
      @controllable.send(command) if @window.button_down? key
    end
  end
  
end