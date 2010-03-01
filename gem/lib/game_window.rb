# Extend this class for your game.
#
# Example:
#   class MyGreatGame < GameWindow
#
class GameWindow < Gosu::Window
  
  attr_reader :space, :font
  
  def initialize
    required_attributes_set?
    
    super self.class.width, self.class.height, self.class.full_screen, 16
    
    self.caption = "Incredible WWII battles!"
    setup_background
    setup_containers
    setup_steps
    setup_waves
    setup_scheduling
    setup_font
    
    setup_battlefield
    setup_objects
    setup_collisions
  end
  
  class << self
    def attr_reader_or_writer name, default
      class_eval <<-BODY
        def #{name} #{name} = #{default}
          @#{name} ||= #{name}
        end
      BODY
    end
    
    #
    #
    attr_reader_or_writer :width, 1200
    #
    #
    attr_reader_or_writer :height, 700
    #
    #
    attr_reader_or_writer :caption, ""
    #
    #
    attr_reader_or_writer :damping, 1.0
    #
    #
    def font name = Gosu::default_font_name, size = 20
      {
        :name => @font_name ||= name,
        :size => @font_size ||= size
      }
    end
    def background path = nil, options = {}
      {
        :path => @background_path ||= path,
        :repeat => @background_repeating ||= (options[:repeating] || false)
      }
    end
    
    #
    #
    def required_attributes
      [:width, :height]
    end
  end
  def required_attributes_set?
    required_attributes.inject(true) do |ok, attribute|
      result = self.class.send attribute
      raise "Required attribute #{attribute} not set" unless result
      ok && result
    end
  end
  
  def setup_background
    if background_path = self.class.background[:path]
      @background_image = Gosu::Image.new self, background_path, true
    end
  end
  def setup_containers
    @moveables = []
    @controls = []
    @remove_shapes = []
    @players = []
  end
  def setup_steps
    @step = 0
    @dt = 1.0 / 60.0
  end
  def setup_waves
    @waves = Waves.new self
  end
  def setup_scheduling
    @scheduling = Scheduling.new
  end
  def setup_fonts
    if font_name = self.class.font[:name]
      @font = Gosu::Font.new self, font_name, (self.class.font[:size] || 20)
    end
  end
  def setup_environment
    @environment = CP::Space.new
    @environment.damping = self.class.damping if self.class.damping
  end
  
  # Core methods used by the extensions "framework"
  #
  
  # Run some code at relative time time.
  #
  # Example:
  #   # Will destroy the object that calls this method
  #   # in 20 steps.
  #   #
  #   window.threaded 20 do
  #     destroy!
  #   end
  #
  def threaded time, code
    @scheduling.add time, code
  end
  
  # Utility Methods
  #
  
  # 
  #
  # Example:
  # * x, y = uniform_random_position
  #
  def uniform_random_position
    [rand(self.width), rand(self.height)]
  end
  
  #
  #
  # Example:
  #   imprint do
  #     circle x, y, radius, :fill => true, :color => :black
  #   end
  #
  def imprint &block
    @background_image.paint &block
  end
  
  # def paint_hill
  #   x, y = uniform_random_position
  #   [80, 40, 20, 10].each do |radius|
  #     circle x, y, radius, :fill => true, :color => [5.0/radius, 0.8, 5.0/radius, 1]
  #   end
  # end
  
  # def generate_landscape
  #   @background_image = Gosu::Image.new self, 'media/battlefield.png', true
  #   @background_image.paint do
  #     20.times { paint_hill }
  #   end
  # end
  
  def randomly_add type
    thing = type.new self
    
    thing.warp_to SCREEN_WIDTH, rand*SCREEN_HEIGHT
    
    register thing
  end
  
  def setup_objects
    wave 10, Enemy,  100
    wave 10, Enemy,  400
    wave 10, Enemy,  700
    wave 10, Enemy, 1000
    
    # add_player_units
  end
  
  def wave amount, type, time
    @waves.add amount, type, time
  end
  
  def small_explosion shape
    explosion = SmallExplosion.new self
    explosion.warp shape.body.p
    remove shape
    register explosion
  end
  
  def setup_collisions
    # @space.add_collision_func :projectile, :projectile, &nil
    # @space.add_collision_func :projectile, :enemy do |projectile_shape, enemy_shape|
    #   @moveables.each { |projectile| projectile.shape == projectile_shape && projectile.destroy }
    # end
  end
  
  # Moveables register themselves here.
  #
  def register moveable
    @moveables << moveable
    moveable.add_to @battlefield
  end
  
  # Moveables unregister themselves here.
  #
  # Note: Use as follows in a Moveable.
  #       
  #       def destroy
  #         threaded do
  #           5.times { sleep 0.1; animate_explosion }
  #           @window.unregister self
  #         end
  #       end
  #
  def unregister moveable
    remove moveable.shape
  end
  
  # Remove this shape the next turn.
  #
  # Note: Internal use. Use unregister to properly remove a moveable.
  #
  def remove shape
    @remove_shapes << shape
  end
  
  # # Adds the first player.
  # #
  # def add_admiral
  #   @player1 = Cruiser.new self, 0x99ff0000
  #   @player1.warp_to 400, 320
  #   
  #   @controls << Controls.new(self, @player1,
  #     Gosu::Button::KbA => :left,
  #     Gosu::Button::KbD => :right,
  #     Gosu::Button::KbW => :full_speed_ahead,
  #     Gosu::Button::KbS => :reverse,
  #     Gosu::Button::Kb1 => :revive
  #   )
  #   
  #   @players << @player1
  #   
  #   register @player1
  # end
  
  def remove_collided
    # This iterator makes an assumption of one Shape per Star making it safe to remove
    # each Shape's Body as it comes up
    # If our Stars had multiple Shapes, as would be required if we were to meticulously
    # define their true boundaries, we couldn't do this as we would remove the Body
    # multiple times
    # We would probably solve this by creating a separate @remove_bodies array to remove the Bodies
    # of the Stars that were gathered by the Player
    #
    @remove_shapes.each do |shape|
      @space.remove_body shape.body
      @space.remove_shape shape
      @moveables.delete_if { |moveable| moveable.shape == shape && moveable.destroy }
    end
    @remove_shapes.clear
  end
  
  def handle_input
    @controls.each &:handle
  end
  
  def reset_forces
    # When a force or torque is set on a Body, it is cumulative
    # This means that the force you applied last SUBSTEP will compound with the
    # force applied this SUBSTEP; which is probably not the behavior you want
    # We reset the forces on the Player each SUBSTEP for this reason
    #
    # @player1.shape.body.reset_forces
    # @player2.shape.body.reset_forces
    # @player3.shape.body.reset_forces
    # @players.each { |player| player.shape.body.reset_forces }
  end
  
  # Checks whether
  #
  def validate
    @moveables.each &:validate_position
  end
  
  def step_once
    # Perform the step over @dt period of time
    # For best performance @dt should remain consistent for the game
    @battlefield.step @dt
  end
  
  def targeting
    @moveables.select { |m| m.respond_to? :target }.each do |gun|
      gun.target *@moveables.select { |m| m.kind_of? Enemy }
    end
  end
  
  # def revive player
  #   return if @moveables.find { |moveable| moveable == player }
  #   register player
  # end
  
  #
  #
  def update
    @step += 1
    # Step the physics environment SUBSTEPS times each update.
    #
    SUBSTEPS.times do
      remove_collided
      reset_forces
      validate
      targeting
      handle_input
      step_once
    end
    @waves.check @step
    @scheduling.step
  end
  
  def draw_background
    @background_image.draw 0, 0, ZOrder::Background, 1.5, 1.2
  end
  
  def draw_moveables
    @moveables.each &:draw
  end
  
  def draw_ui
    # @font.draw "P1 Score: ", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffff0000
  end
  
  def draw
    draw_background
    draw_moveables
    draw_ui
  end
  
  # Escape exits.
  #
  def button_down id
    close if id == Gosu::Button::KbEscape
  end
  
end