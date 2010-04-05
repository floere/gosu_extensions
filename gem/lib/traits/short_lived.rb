module ShortLived
  
  class LifetimeMissingError < RuntimeError
    def initialize
      super <<-MESSAGE
        A ShortLived thing must define method
          lifetime lifetime = nil, &block
        with either params
          lifetime 74 # some value
        or
          lifetime { 50 + rand(50) } # some block
        to define how long the thing should live until it is destroyed.
      MESSAGE
    end
  end
  
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