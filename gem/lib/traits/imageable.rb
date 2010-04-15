# In an Imageable, you either need to define method
#   image path, *args
# for an unchanging image
# or
#   sequenced_image path, width, height, frequency = 10, &block
# for a sprite sequence.
# Or override
#   method image
# or set an image dynamically.
#
module Imageable extend Trait
  
  class ImageMissingError < RuntimeError
    def initialize
      super <<-MESSAGE
        
        In an Imageable, you either need to define method
          image path, *args
        for an unchanging image
        or
          sequenced_image path, width, height, frequency = 10, &block
        for a sprite sequence.
        Or override
          method image
        or set an image dynamically.
        
      MESSAGE
    end
  end
  
  def self.included klass
    klass.extend ClassMethods
  end
  
  def initialize *args
    super *args
  end

  attr_writer :image
  def image
    @image || raise(ImageMissingError.new)
  end
  # Set this thing's image using a path.
  #
  def image_from path, *args
    self.image = Gosu::Image.new self.window, File.join(Resources.root, path), *args
  end
  # Set this thing's image in the form of a sequenced image.
  #
  def sequenced_image_from path, width, height, frequency = 10, &block
    @image_sequence_started = Time.now
    self.image = Gosu::Image::load_tiles self.window, File.join(Resources.root, path), width, height, false
  end
  
  module ClassMethods
    
    def image path, *args
      InitializerHooks.register self do
        image_from path, *args
      end
    end
    
    def sequenced_image path, width, height, frequency = 10, &block
      InitializerHooks.register self do
        sequenced_image_from path, width, height, frequency, &block
      end
      # divider = 1000 / frequency
      
      # Override image.
      #
      define_method :image do
        @image[(block ? block : lambda { (Time.now - @image_sequence_started)*frequency % @image.size })[]]
      end
    end
    
  end
  
end