module ShortLived
  
  def self.included klass
    klass.extend ClassMethods
  end
  
  def initialize window
    super window
    
    threaded self.lifetime do
      self.destroy!
    end
  end
  
  module ClassMethods
    
    def lifetime lifetime = nil, &block
      block = lambda { lifetime } unless block_given?
      define_method :lifetime, &block
    end
    
  end
  
end