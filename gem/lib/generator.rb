module Generator
  
  def self.included base
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def generates moveable_class, seconds
      self.send :include, InstanceMethods
      @@generates_moveable_class = moveable_class
      @@generates_moveable_class_every_seconds = seconds
    end
    
  end
  
  module InstanceMethods
    
    def start_generating
      threaded 5 do
        generate
      end
    end
    
    def generate
      generated = @@generates_moveable_class.new self.window
      generated.warp self.position
      self.window.register generated
    end
    
  end
  
end