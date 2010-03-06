module Generator
  
  def self.included base
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def generates klass, rate, til = 100, offset = 0
      self.send :include, InstanceMethods
      
      InitializerHooks.register self do
        start_generating klass, rate, til, offset
      end
    end
    
  end
  
  module InstanceMethods
    
    def generation klass, every_rate, til
      lambda do
        generate klass
        self.start_generating klass, every_rate, til - every_rate, every_rate
      end
    end
    
    def start_generating klass, every_rate, til, offset
      return if til <= 0
      threaded offset, &generation(klass, every_rate, til)
    end
    
    def generate klass
      generated = klass.new self.window
      generated.warp self.position
      self.window.register generated
    end
    
  end
  
end