# When hitpoints are at zero or lower, it calls kill! if available, destroy! else.
#
module Hitpoints extend Trait
  
  # Prints an amount of information on these capabilities.
  #
  manual <<-MANUAL
    Defines:
      hitpoints <some trait>
    
    Example:
      hitpoints 10_000
    
    Call hit!(damage = 1) to remove hitpoints. This will call
    * callback hit if hitpoints are still higher than 0.
    * kill!, and if not available, destroy! if hitpoints are lower than 0.
  MANUAL
  
  def self.included target_class
    target_class.extend ClassMethods
  end
  
  module ClassMethods
    
    # Define the amount of hitpoints of the thing.
    #
    def hitpoints amount
      include InstanceMethods
      class_inheritable_accessor :prototype_hitpoints
      self.prototype_hitpoints = amount
      
      hook = lambda { self.hitpoints = self.class.prototype_hitpoints }
      InitializerHooks.register self, &hook
    end
    
  end
  
  module InstanceMethods
    
    attr_accessor :hitpoints
    
    # Override to handle hit.
    #
    def hit
      
    end
    
    # Hit the thing with that much damage.
    #
    # hit!-s if hitpoints higher than 0
    # kill!-s if lower, or destroy!-s if kill!
    # is not available.
    #
    def hit! damage = 1
      self.hitpoints -= damage
      hit if hitpoints > 0
      respond_to?(:kill!) ? kill! : destroy! if hitpoints < 0
    end
    
    # kill! must reset hitpoints
    #
    # TODO Do irrespective of kill! call order
    #
    def kill!
      super
      self.hitpoints = self.class.prototype_hitpoints
    end
    
  end
  
end