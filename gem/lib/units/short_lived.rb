class ShortLived < Moveable
  
  def initialize window
    super window
    
    threaded self.lifetime do
      p [:destroy, object_id] if self.class == Smoke
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