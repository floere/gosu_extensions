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
              :scheduling,
              :collisions
  attr_accessor :background_options,
                :stop_condition,
                :proceed_condition
  
  def initialize
    setup_window
    setup_moveables
    setup_remove_shapes
    setup_controls
    setup_window_control # e.g. ESC => exits
    
    @collisions = []
    
    after_initialize
    
    super self.screen_width, self.screen_height, self.full_screen, 16
    
    setup_background
    
    setup_steps
    setup_scheduling
    setup_font
    setup_uis
    
    setup_containers
    
    setup_environment
    
    setup_enemies
    setup_players
    setup_waves
    
    setup_collisions
    
    install_main_loop
    
    after_setup
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
    def background path_or_color = Gosu::Color::WHITE
      InitializerHooks.register self do
        self.background_options = path_or_color
      end
    end
    def full_screen
      InitializerHooks.register self do
        self.full_screen = true
      end
    end
    
    attr_accessor :collisions
    def no_collision this, that = this
      # The next line doesn't work, as &nil == nil
      # collision this, that, &Collision::None
      InitializerHooks.register self do
        self.collisions << Collision.new(self, this, that)
      end
    end
    def collision this, that = this, &definition
      definition ||= Collision::Simple
      InitializerHooks.register self do
        self.collisions << Collision.new(self, this, that, &definition)
      end
    end
    
    # Stop the game if this condition is true.
    #
    # Block will instance eval in the window.
    #
    # Use the callback after_stopping.
    #
    def stop_on &condition
      InitializerHooks.register self do
        self.stop_condition = condition
      end
    end
    
    # # Proceed if this condition is true.
    # #
    # def proceed_on &condition
    #   InitializerHooks.register self do
    #     self.proceed_condition = condition
    #   end
    # end
    
  end
  
  # Setup methods
  #
  
  def setup_window
    self.caption = self.class.caption || ""
  end
  def setup_background
    @background = Background.new self
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
  def setup_uis
    @uis = []
  end
  def setup_environment
    @environment = Environment.new
    class << @environment
      attr_accessor :window
    end
    @environment.window = self
    @environment.damping = -self.damping + 1 # recalculate the damping such that 0.0 has no damping.
  end
  # Callbacks.
  #
  def setup_players; end
  def setup_enemies; end
  def setup_waves; end
  def after_setup; end
  def after_stopping; end
  def before_proceeding; end
  def step; end # The most important callback
  
  #
  #
  # Example:
  #   collisions do
  #     add_collision_func ...
  #
  def setup_collisions
    self.collisions.each { |collision| collision.install_on(environment) }
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
  def add_controls_for object, mapping = nil
    @controls << Control.new(self, object, mapping)
  end
  
  # Main loop methods.
  #
  
  #
  #
  def update
    @current_loop.call
  end
  def stop
    @current_loop = lambda do
      proceed if proceed_condition && instance_eval(&proceed_condition)
      advance_step
      handle_input
    end
    after_stopping
  end
  def proceed
    before_proceeding
    @current_loop = main_loop
  end
  # Advances to the next step in the game.
  #
  def advance_step
    @step += 1
    @scheduling.step
  end
  def next_step
    stop if stop_condition && instance_eval(&stop_condition)
    advance_step
    step
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
    # explicitly call unregister_ui thing if you want it
    remove thing.shape
  end
  # Register a user interfaceable object.
  #
  def register_ui thing
    @uis << thing
  end
  def unregister_ui thing
    @uis.delete thing
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
  alias after threaded
  
  
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
  def add type, x = nil, y = nil, &random_function
    thing = type.new self
    position = x && y && [x, y] || random_function && random_function[]
    thing.warp_to *position
    register thing
  end
  def randomly_add type
    add type, *uniform_random_position
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
    @background.draw
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
    @uis.each(&:draw_ui)
  end
  
  # Input handling.
  #
  
  # 
  #
  def button_down *
    handle_input
  end
  
end