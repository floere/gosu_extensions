# A thing is destroyed if a number of lives has been passed.
#
module Lives extend Trait
  
  # TODO def revive!
  #
  
  # Prints an amount of information on these capabilities.
  #
  manual <<-MANUAL
    Defines:
      lives <some trait>
    
    Example:
      lives 10
    
    Call kill! to remove a live. Override killed! to exhibit behaviour.
  MANUAL
  
  def self.included target_class
    target_class.extend IncludeMethods
    target_class.send :include, InstanceMethods
  end
  
  module IncludeMethods
    
    # Define the amount of lives in the class.
    #
    def lives amount
      InitializerHooks.register self do
        self.lives = amount
      end
      attr_reader :lives # override the default
    end
    
  end
  
  module InstanceMethods
    
    attr_writer :lives
    
    def lives
      3
    end
    
    # Does three things:
    # * Deduct 1 live.
    # * Check to see if the amount is 0.
    # * Calls #destroy! if yes.
    #
    def killed!
      
    end
    def kill!
      self.lives -= 1
      killed! if self.lives > 0
      destroy! if self.lives == 0
    end
    
  end
  
end