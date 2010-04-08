# Extend this class for your game.
#
# Example:
#   class MyGreatGame < GameWindow
#
class GameWindow < Gosu::Window
  
  include InitializerHooks
  
  # TODO handle more elegantly
  #
  def window
    self
  end
  def destroyed?
    false
  end
  
  include ItIsA # Move up to standard object, also from thing
  
  attr_writer :full_screen,
              :font_name,
              :font_size,
              :damping,
              :caption,
              :screen_width,
              :screen_height,
              :gravity_vector
  attr_reader :environment,
              :moveables,
              :font,
              :scheduling
  attr_accessor :background_path,
                :background_hard_borders
  
  def initialize
    setup_window
    setup_moveables
    setup_remove_shapes
    setup_controls
    setup_window_control # e.g. ESC => exits
    
    after_initialize
    
    super self.screen_width, self.screen_height, self.full_screen, 16
    
    setup_background
    
    setup_steps
    setup_scheduling
    setup_font
    
    setup_containers
    
    setup_environment
    
    setup_enemies
    setup_players
    setup_waves
    
    setup_collisions
    
    install_main_loop
  end
  
  # This is the main game loop.
  #
  def main_loop
    @main_loop ||= lambda do
      # Smoother, but slower: GC.start if rand > 0.98
      next_step
      SUBSTEPS.times do
        remove_shapes
        move
        targeting
        handle_input
        step_physics
      end
    end
  end
  def install_main_loop
    @current_loop = main_loop
  end
  
  def media_path
    @media_path || 'media'
  end
  def full_screen
    @full_screen || false
  end
  def font_name
    @font_name || Gosu::default_font_name
  end
  def font_size
    @font_size || 20
  end
  def damping
    @damping || 0.001
  end
  def caption
    @caption || ""
  end
  def screen_width
    @screen_width || DEFAULT_SCREEN_WIDTH
  end
  def screen_height
    @screen_height || DEFAULT_SCREEN_HEIGHT
  end
  def gravity_vector
    @gravity_vector || @gravity_vector = CP::Vec2.new(0, 0.98/SUBSTEPS)
  end
  
  class << self
    def gravity amount = 0.98
      InitializerHooks.register self do
        self.gravity_vector = CP::Vec2.new(0, amount.to_f/SUBSTEPS)
      end
    end
    def width value = DEFAULT_SCREEN_WIDTH
      InitializerHooks.register self do
        self.screen_width = value
      end
    end
    def height value = DEFAULT_SCREEN_HEIGHT
      InitializerHooks.register self do
        self.screen_height = value
      end
    end
    def caption text = ""
      InitializerHooks.register self do
        self.caption = text
      end
    end
    def damping amount = 0.0
      InitializerHooks.register self do
        self.damping = amount
      end
    end
    def font name = Gosu::default_font_name, size = 20
      InitializerHooks.register self do
        self.font_name = name
        self.font_size = size
      end
    end
    def background path, options = {}
      InitializerHooks.register self do
        self.background_path = path
        self.background_hard_borders = options[:hard_borders] || false
      end
    end
    def full_screen
      InitializerHooks.register self do
        self.full_screen = true
      end
    end
    def collisions &block
      raise "collisions are defined in a block" unless block_given?
      InitializerHooks.register self do
        @collision_definitions = block
      end
    end
  end
  
  # Setup methods
  #
  
  def setup_window
    self.caption = self.class.caption || ""
  end
  def setup_background
    if self.background_path
      @background_image = Gosu::Image.new self, File.join(Resources.root, self.background_path), self.background_hard_borders
    end
  end
  def setup_moveables
    @moveables = Moveables.new
  end
  def setup_remove_shapes
    @remove_shapes = RemoveShapes.new
  end
  def setup_controls
    @controls = Controls.new
  end
  def setup_window_control
    add_controls_for self
  end
  def setup_containers
    @players = []
    @waves   = Waves.new self, @scheduling
  end
  def setup_steps
    @step = 0
    @dt = 1.0 / 60.0
  end
  def setup_scheduling
    @scheduling = Scheduling.new
  end
  def setup_font
    @font = Gosu::Font.new self, self.font_name, self.font_size
  end
  def setup_environment
    @environment = CP::Space.new
    class << @environment
      attr_accessor :window
    end
    @environment.window = self
    @environment.damping = -self.damping + 1 # recalculate the damping such that 0.0 has no damping.
  end
  # Override.
  #
  def setup_players; end
  def setup_enemies; end
  def setup_waves; end
  #
  #
  # Example:
  #   collisions do
  #     add_collision_func ...
  #
  def setup_collisions
    self.environment.instance_eval &@collision_definitions if @collision_definitions
  end
  
  # Add controls for a player.
  #
  # Example:
  #   add_controls_for @player1, Gosu::Button::KbA => :left,
  #                              Gosu::Button::KbD => :right,
  #                              Gosu::Button::KbW => :full_speed_ahead,
  #                              Gosu::Button::KbS => :reverse,
  #                              Gosu::Button::Kb1 => :revive
  #
  def add_controls_for object
    @controls << Control.new(self, object)
  end
  
  # Main loop methods.
  #
  
  # TODO implement hooks.
  #
  def update
    @current_loop.call
  end
  # Advances to the next step in the game.
  #
  def next_step
    @step += 1
    @scheduling.step
  end
  # Each step, this is called to handle any input.
  #
  def handle_input
    @controls.handle
  end
  # Does a single step.
  #
  def step_physics
    @environment.step @dt
  end
  # Moves each moveable.
  #
  def move
    @moveables.move
  end
  # Handles the targeting process.
  #
  def targeting
    @moveables.targeting
  end
  # Remove the shapes that are marked for removal.
  #
  def remove_shapes
    @remove_shapes.remove_from @environment, @moveables
  end
  
  # Adding things.
  #
  
  # Moveables register themselves here.
  #
  def register moveable
    @moveables.register moveable
    moveable.add_to @environment
  end
  # Things unregister themselves here.
  #
  # Note: Use as follows in a Thing.
  #       
  #       def destroy
  #         threaded do
  #           5.times { sleep 0.1; animate_explosion }
  #           @window.unregister self
  #         end
  #       end
  #
  def unregister thing
    remove thing.shape
  end
  # Remove this shape the next turn.
  #
  # Note: Internal use. Use unregister to properly remove a moveable.
  #
  def remove shape
    @remove_shapes.add shape
  end
  # Is the thing registered?
  #
  def registered? thing
    @moveables.registered? thing
  end
  
  # Scheduling
  #
  
  # Run some code at relative time <time>.
  #
  # Example:
  #   # Will destroy the object that calls this method
  #   # in 20 steps.
  #   #
  #   window.threaded 20 do
  #     destroy!
  #   end
  #
  def threaded time = 1, &code
    @scheduling.add time, &code
  end
  
  
  # Utility Methods
  #
  
  # Example:
  # * x, y = uniform_random_position
  #
  def uniform_random_position
    [rand(self.width), rand(self.height)]
  end
  # Randomly adds a Thing to a uniform random position.
  #
  def randomly_add type
    thing = type.new self
    thing.warp_to *uniform_random_position
    register thing
  end
  # Revives the player if not already in.
  #
  def revive player
    register player unless registered?(player) # player.registered?
  end
  
  # Drawing methods
  #
  
  # Method called by Gosu.
  #
  def draw
    draw_background
    draw_ambient
    draw_moveables
    draw_ui
  end
  # Draws a background image.
  #
  def draw_background
    @background_image.draw 0, 0, Layer::Background, 1.0, 1.0 if @background_image
  end
  # Draw ambient objects, like asteroids or the like that do not influence the player.
  #
  def draw_ambient
    
  end
  # Draw the moveables.
  #
  def draw_moveables
    @moveables.draw
  end
  # Override for example with
  # @font.draw "P1 Score: ", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffff0000
  #
  def draw_ui
    
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
  
  # Input handling.
  #
  
  # 
  #
  def button_down *
    handle_input
  end
  
end