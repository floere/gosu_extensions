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
      MESSAGE
    end
  end
  
  def self.included klass
    klass.extend ClassMethods
  end
  
  def initialize window
    raise ImageMissingError.new unless self.respond_to? :image
    super window
  end
  
  module ClassMethods
    
    def image path, *args
      InitializerHooks.register self do
        @image = Gosu::Image.new self.window, File.join(Resources.root, path), *args
      end
      define_method :image do
        @image
      end
    end
    
    def sequenced_image path, width, height, frequency = 10, &block
      InitializerHooks.register self do
        @image_sequence_started = Time.now
        @image = Gosu::Image::load_tiles self.window, File.join(Resources.root, path), width, height, false
      end
      # divider = 1000 / frequency
      define_method :image do
        @image[(block ? block : lambda { (Time.now - @image_sequence_started)*frequency % @image.size })[]]
      end
    end
    
  end
  
end