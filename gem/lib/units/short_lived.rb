class ShortLived < Moveable
  
  def initialize window
    super window
    
    threaded self.lifetime do
      self.destroy!
    end
  end
  
  class << self
    def lifetime lifetime = nil, &block
      if block_given?
        define_method :lifetime, &block
      else
        define_method :lifetime do lifetime end
      end
    end
  end
  
end