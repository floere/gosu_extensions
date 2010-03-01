class ShortLived < Moveable
  
  class_inheritable_accessor :lifetime
  
  def initialize window
    super window
    
    threaded self.lifetime do
      self.destroy!
    end
  end
  
  def lifetime= duration
    @lifetime = duration
  end
  def lifetime
    @lifetime
  end
  
end