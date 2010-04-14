module Generator extend Trait
  
  def self.start klass, *args
    [:start_generating, klass, *args]
  end
  Start = :start_generating
  
  def self.included base
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def generates klass, options = {}
      self.send :include, InstanceMethods
      
      rate   = options[:every]
      til    = options[:until]
      offset = options[:starting_at]
      
      class_eval <<-GENERATION
def start_generating klass = #{klass.name}, every_rate = #{rate || 10}, til = #{til || false}, offset = #{offset || rate || 10}
  return if til && til <= 0
  threaded offset, &generation(klass, every_rate, til)
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
    
    #
    #
    def destroyed!
      stop_generating!
    end
    
    #
    #
    def stop_generating!
      @stop_generating = true
    end
    
    #
    #
    def generation klass, every_rate, til
      return lambda {} if @stop_generating
      lambda do
        self.generate klass
        til = til - every_rate if til
        self.start_generating klass, every_rate, til, every_rate
      end
    end
    
  end
  
  # Returns the generated thing.
  #
  # TODO generate klass, times = 1, &after_generation ?
  #
  def generate klass
    generated = klass.new self.window
    generated.warp self.position * 1.0
    generated.show
    generated
  end
  
end