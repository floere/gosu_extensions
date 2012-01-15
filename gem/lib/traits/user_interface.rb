#
#
module UserInterface extend Trait
  
  def self.included base
    base.extend ClassMethods
  end
  
  # Call this to install an UI on all instances of
  # this class at the given position.
  #
  module ClassMethods
    attr_accessor :ui
    def ui x = 20, y = 10, color = Gosu::Color::BLACK, &display
      InitializerHooks.append self do
        ui x, y, color, &display
      end
    end
  end
  
  # Call this to dynamically add itself to the ui displaying.
  #
  def ui x = 20, y = 10, color = Gosu::Color::BLACK, &display
    singleton_class.instance_eval do
      define_method :draw_ui do
        window.font.draw instance_eval(&display), x, y, Layer::UI, 1.0, 1.0, color
      end
    end
    window.register_ui self
  end
  
end