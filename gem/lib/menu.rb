class Menu < Thing
  
  include Controllable
  
  # TODO Move away
  #
  controls Gosu::Button::KbP => :continue
  
  def initialize window
    @controls = []
    super window
  end
  
  # TODO duplicate
  #
  def handle_input
    @controls.each &:handle
  end
  
  def continue
    window.continue
  end
  
  def loop
    @loop ||= lambda do
      # self.handle_input
    end
  end
  
end