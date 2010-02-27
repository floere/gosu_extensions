# A thing is destroyed if a number of lives has been passed.
#
module Lives
  
  # Prints an amount of information on these capabilities.
  #
  # Examples:
  # * Lives.debug
  # * include Lives.debug
  #
  def self.debug
    puts <<-DOC
      
    DOC
    self
  end
  
  def self.included target_class
    target_class.extend IncludeMethods
  end
  
  module IncludeMethods
    
    def lives amount
      include InstanceMethods
      class_inheritable_accessor :prototype_lives
      self.prototype_lives = amount
      
      hook = lambda { self.lives = self.class.prototype_lives }
      InitializerHooks.register self, hook
    end
    
  end
  
  module InstanceMethods
    
    attr_accessor :lives
    
    # Does three things:
    # * Deduct 1 live.
    # * Check to see if the amount is 0.
    # * Calls #destroy if yes.
    #
    def hit!
      self.lives -= 1
      destroy if self.lives == 0
    end
    
  end
  
end