# This is a convenience trait.
#
# Instead of 
#
module Controllable extend Trait
  
  def self.included controllable
    controllable.extend ClassMethods
  end
  
  module ClassMethods
    
    # TODO alternate controls handling!
    #
    
    def controls mapping
      attr_accessor :controls_mapping
      InitializerHooks.register self do
        self.controls_mapping = mapping
        self.window.add_controls_for self
      end
    end
    
  end
  
end