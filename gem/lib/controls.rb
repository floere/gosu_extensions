# Controls for a controllable.
# Example:
#   # Note: left, right, full_speed_ahead, reverse, revive are
#   #       methods on the @player.
#   #
#   @controls << Controls.new(self, @player,
#     Gosu::Button::KbA => :left,
#     Gosu::Button::KbD => :right,
#     Gosu::Button::KbW => :full_speed_ahead,
#     Gosu::Button::KbS => :reverse,
#     Gosu::Button::Kb1 => :revive
#   )
#
#
#
class Controls
  
  #
  #
  def initialize window, controllable
    @window = window
    @controllable = controllable
    @mapping = controllable.controls_mapping
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