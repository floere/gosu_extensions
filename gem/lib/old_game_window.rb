# Extend this class for your game.
#
# Example:
#   class MyGreatGame < GameWindow
#
class GameWindow < Gosu::Window
  
  attr_reader :space, :font
  
  def initialize
    # set to true for fullscreen
    super SCREEN_WIDTH, SCREEN_HEIGHT, true, 16
    
    init
    setup_battlefield
    setup_objects
    setup_collisions
  end
  
  def init
    self.caption = "Incredible WWII battles!"
    
    generate_landscape
    
    @font = Gosu::Font.new self, Gosu::default_font_name, 20
    @moveables = []
    @controls = []
    @remove_shapes = []
    @players = []
    @waves = Waves.new self
    @scheduling = Scheduling.new
    @step = 0
    @dt = 1.0 / 60.0
  end
  
  def paint_hill
    x, y = uniform_random_position
    [80, 40, 20, 10].each do |radius|
      circle x, y, radius, :fill => true, :color => [5.0/radius, 0.8, 5.0/radius, 1]
    end
  end
  
  def uniform_random_position
    [rand(SCREEN_WIDTH), rand(SCREEN_HEIGHT)]
  end
  
  def generate_landscape
    @background_image = Gosu::Image.new self, 'media/battlefield.png', true
    @background_image.paint do
      20.times { paint_hill }
    end
  end
  
  def setup_battlefield
    @battlefield = CP::Space.new
    @battlefield.damping = 1.0 # 0.0 # full damping?
  end
  
  def imprint &block
    @background_image.paint &block
  end
  
  def threaded time, code
    @scheduling.add time, code
  end
  
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