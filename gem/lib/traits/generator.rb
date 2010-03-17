module Generator
  
  def self.included base
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def generates klass, options = {}
      self.send :include, InstanceMethods
      
      rate   = options[:every]
      til    = options[:until]
      offset = options[:starting_at]
      
      define_method :generated_class do
        klass
      end
      class_eval <<-GENERATION
def start_generating! every_rate = #{rate || 10}, til = #{til || false}, offset = #{offset || rate || 10}
  return if til && til <= 0
  threaded offset, &generation(generated_class, every_rate, til)
end
      GENERATION
      
      # If an offset is given, start generating after the offset, else after start_generating is called.
      #
      if offset
        InitializerHooks.register self do
          start_generating!
        end
      end
      
    end
    
  end
  
  module InstanceMethods
    
    def destroy!
      stop_generating!
      super
    end
    
    def stop_generating!
      @stop_generating = true
    end
    
    def generation klass, every_rate, til
      return lambda {} if @stop_generating
      lambda do
        self.generate klass
        til = til - every_rate if til
        self.start_generating! every_rate, til, every_rate
      end
    end
    
    def generate klass
      generated = klass.new self.window
      generated.warp self.position
      self.window.register generated
    end
    
  end
  
end