#
#
class Wave
  
  attr_reader :generated_type, :execution_amount, :positioning_function
  
  UniformRandom = lambda { |window, instance| instance.warp_to *window.uniform_random_position }
  TopBorder     = lambda { |window, instance| instance.warp_to rand(window.width), 0 }
  RightBorder   = lambda { |window, instance| instance.warp_to window.width, rand(window.height) }
  BottomBorder  = lambda { |window, instance| instance.warp_to rand(window.width), window.height }
  LeftBorder    = lambda { |window, instance| instance.warp_to 0, rand(window.height) }
  
  #
  #
  # Note: The function needs a param generated_type.
  #
  def initialize generated_type, execution_amount = 1, &positioning_function
    @generated_type      = generated_type
    @execution_amount    = execution_amount
    @positioning_function = positioning_function || UniformRandom
  end
  
  #
  #
  def for_scheduling window
    lambda do
      self.execution_amount.times do
        instance = self.generated_type.new window
        window.register instance
        self.positioning_function.call(window, instance)
      end
    end
  end
  
end