module ShortLived
  
  # TODO Explain better what to do.
  #
  class LifetimeMissingError < StandardError; end
  
  def self.included klass
    klass.extend ClassMethods
  end
  
  def initialize window
    raise LifetimeMissingError.new unless self.respond_to? :lifetime
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