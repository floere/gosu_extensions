class ShortLived < Moveable
  
  def initialize window
    super window
    
    threaded self.lifetime do
      self.destroy!
    end
  end
  
  class << self
    def lifetime lifetime = nil, &block
      block = lambda { lifetime } unless block_given?
      define_method :lifetime, &block
    end
  end
  
end