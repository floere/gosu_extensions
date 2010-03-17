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
def start_generating every_rate = #{rate || 10}, til = #{til || 100}, offset = #{offset || 0}
  return if til <= 0
  threaded offset, &generation(generated_class, every_rate, til)
end
      GENERATION
      
      # If an offset is given, start generating after the offset, else after start_generating is called.
      #
      if offset
        InitializerHooks.register self do
          start_generating
        end
      end
      
    end
    
  end
  
  module InstanceMethods
    
    # See in #generates.
    #
    # def start_generating every_rate, til, offset, klass
    #   return if til <= 0
    #   threaded offset, &generation(klass, every_rate, til)
    # end
    
    def generation klass, every_rate, til
      lambda do
        self.generate klass
        self.start_generating every_rate, til - every_rate, every_rate
      end
    end
    
    def generate klass
      generated = klass.new self.window
      generated.warp self.position
      self.window.register generated
    end
    
  end
  
end