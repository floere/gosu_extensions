#
#
# TODO This is almost a generator.
#
class Wave
  
  attr_reader :generated_type, :execution_amount, :positioning_function
  
  class << self
    def uniform_random
      lambda { |window, instance| instance.warp_to *window.uniform_random_position }
    end
    def top_border offset = 0
      lambda { |window, instance| instance.warp_to rand(window.width), -offset }
    end
    def right_border offset = 0
      lambda { |window, instance| instance.warp_to window.width+offset, rand(window.height) }
    end
    def bottom_border offset = 0
      lambda { |window, instance| instance.warp_to rand(window.width), window.height+offset }
    end
    def left_border offset = 0
      lambda { |window, instance| instance.warp_to -offset, rand(window.height) }
    end
  end
  
  #
  #
  # Note: The function needs a param generated_type.
  #
  def initialize generated_type, execution_amount = 1, &positioning_function
    @generated_type      = generated_type
    @execution_amount    = execution_amount
    @positioning_function = positioning_function || Wave.uniform_random
  end
  
  #
  #
  def for_scheduling window
    lambda do
      self.execution_amount.times do
        instance = self.generated_type.new window
        instance.show
        self.positioning_function.call(window, instance)
      end
    end
  end
  
end