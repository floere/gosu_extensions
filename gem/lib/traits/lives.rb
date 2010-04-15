# A thing is destroyed if a number of lives has been passed.
#
module Lives extend Trait
  
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
  end
  
  module IncludeMethods
    
    # Define the amount of lives in the class.
    #
    def lives amount = 3
      cattr_accessor :prototype_lives
      self.prototype_lives = amount
      InitializerHooks.register self do
        self.lives = amount
      end
    end
    
  end
  
  attr_accessor :lives
  
  # Override to handle kill!
  #
  def killed; end
  
  # Does three things:
  # * Deduct 1 live.
  # * Check to see if the amount is 0.
  # * Calls #destroy! if yes.
  #
  def kill!
    self.lives -= 1
    killed   if self.lives > 0
    destroy! if self.lives == 0
  end
  
  # Revive extension.
  #
  def revive
    self.lives = self.class.prototype_lives
    super
  end
  
end