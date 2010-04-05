#
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
      hook = lambda do
        if self.controls_mapping
          # primary controls taken, use alternate controls
          self.controls_mapping = self.alternate_controls_mapping if self.respond_to? :alternate_controls_mapping
        else
          self.controls_mapping = mapping
        end
        self.window.add_controls_for self
      end
      InitializerHooks.register self, &hook
    end
    
    def alternate_controls mapping
      attr_accessor :alternate_controls_mapping
      hook = lambda do
        if self.controls_mapping
          # primary controls taken, use alternate controls
          self.controls_mapping = self.alternate_controls_mapping if self.respond_to? :alternate_controls_mapping
        else
          self.controls_mapping = mapping
        end
      end
      InitializerHooks.register self, &hook
    end
    
  end
  
end