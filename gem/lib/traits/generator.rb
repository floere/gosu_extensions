module Generator
  
  def self.included base
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def generates klass, options = {}
      self.send :include, InstanceMethods
      
      rate   = options[:every]
      til    = options[:until] || 100
      offset = options[:starting_at] || 1
      
      InitializerHooks.register self do
        start_generating klass, rate, til, offset
      end
      
    end
    
  end
  
  module InstanceMethods
    
    def start_generating klass, every_rate, til, offset
      return if til <= 0
      p [:threaded, offset, Time.now.usec]
      threaded offset, &generation(klass, every_rate, til)
    end
    
    def generation klass, every_rate, til
      lambda do
        p [:called, Time.now.usec]
        self.generate klass
        self.start_generating klass, every_rate, til - every_rate, every_rate
      end
    end
    
    def generate klass
      generated = klass.new self.window
      generated.warp self.position
      self.window.register generated
    end
    
  end
  
end