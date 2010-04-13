#
#
class Background
  
  #
  #
  attr_reader :window, :draw_function
  
  #
  #
  def initialize window
    @window        = window
    @draw_function = functionify window.background_options
  end
  
  def functionify path_or_color
    Gosu::Color === path_or_color ? color_draw_function(path_or_color) : image_draw_function(path_or_color)
  end
  
  #
  #
  def color_draw_function color
    lambda do
      window.draw_quad(0,            0,             color,
                       window.width, 0,             color,
                       window.width, window.height, color,
                       0,            window.height, color,
                       0, :default)
    end
  end
  
  #
  #
  def image_draw_function path
    image = Gosu::Image.new window, File.join(Resources.root, path), true
    lambda do
      image.draw 0, 0, Layer::Background, 1.0, 1.0
    end
  end
  
  #
  #
  def draw
    draw_function.call
  end
  
end