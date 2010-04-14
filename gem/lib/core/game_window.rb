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
              :gravity_vector,
              :background_options
  attr_reader :environment,
              :sprites,
              :things,
              :objects,
              :font,
              :scheduling
  attr_accessor :stop_condition,
                :proceed_condition,
                :collisions
  
  def initialize
    setup_window
    
    setup_environment
    
    setup_sprites
    setup_things
    setup_objects
    
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
    
    setup_enemies
    setup_players
    setup_waves
    
    setup_collisions
    
    setup_apply_damping
    
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
        move
        targeting
        handle_input
        remove_marked
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
    @damping || 0.5
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
  def background_options
    # default is no background
  end
  
  class << self
    
    # Sets the Esc button to close the window.
    #
    def default_controls
      it_is Controllable
      controls Gosu::Button::KbEscape => :close
    end
    
    # Gravity acting.
    #
    # If you want to set the gravity_vector on the window,
    # use its writer: window.gravity_vector = CP::Vec2.new(1, 2)
    #
    def gravity amount = 0.98
      InitializerHooks.register self do
        self.gravity_vector = CP::Vec2.new(0, amount.to_f/SUBSTEPS)
      end
    end
    # How much is movement damped?
    #
    def damping amount = 0.0
      InitializerHooks.register self do
        self.damping = amount
      end
    end
    
    # Size of the window. Use either width, height, or just size.
    #
    def size w = DEFAULT_SCREEN_WIDTH, h = DEFAULT_SCREEN_HEIGHT
      width w
      height h
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
    
    # Window caption.
    #
    def caption text = ""
      InitializerHooks.register self do
        self.caption = text
      end
    end
    
    def font name = Gosu::default_font_name, size = 20
      InitializerHooks.register self do
        self.font_name = name
        self.font_size = size
      end
    end
    def background path_or_color = Gosu::Color::WHITE
      attr_reader :background_options
      InitializerHooks.register self do
        self.background_options = path_or_color
      end
    end
    def full_screen
      InitializerHooks.register self do
        self.full_screen = true
      end
    end
    
    def no_collision this, that = this
      # The next line doesn't work, as &nil == nil
      # collision this, that, &Collision::None
      InitializerHooks.register self do
        self.collisions << Collision.new(things, this, that)
      end
    end
    def collision this, that = this, &definition
      definition ||= Collision::Simple
      InitializerHooks.register self do
        self.collisions << Collision.new(things, this, that, &definition)
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
  def setup_sprites
    @sprites = Sprites.new
  end
  def setup_things
    @things = Things.new @environment
  end
  def setup_objects
    @objects = Objects.new things, sprites
  end
  def setup_controls
    @controls = Controls.new
  end
  def setup_window_control
    add_controls_for self
  end
  def setup_containers
    @waves = Waves.new self, @scheduling
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
  end
  def setup_apply_damping
    # recalculate the damping such that 0.0 has no damping.
    #
    @environment.damping = -self.damping + 1
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
    @objects.move
  end
  # Handles the targeting process.
  #
  def targeting
    @things.targeting
  end
  # Remove the shapes that are marked for removal.
  #
  def remove_marked
    @objects.remove_marked
  end
  
  # Adding things.
  #
  # Register a user interfaceable object.
  #
  def register_ui thing
    @uis << thing
  end
  def unregister_ui thing
    @uis.delete thing
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
  # Note: You can also use after instead of threaded.
  #
  def threaded time = 1, &code
    @scheduling.add time, &code
  end
  alias after threaded
  
  
  # Utility Methods
  #
  
  # Example:
  # * x, y = uniform_random_position
  # * warp_to *uniform_random_position
  #
  def uniform_random_position
    [rand(self.width), rand(self.height)]
  end
  # Randomly adds a Thing to a uniform random position.
  #
  # Returns the new thing
  #
  def add type, x = nil, y = nil, &random_function
    thing = type.new self
    position = x && y && [x, y] || random_function && random_function[]
    thing.warp_to *position
    thing.show
    thing
  end
  def randomly_add type
    add type, *uniform_random_position
  end
  
  # Drawing methods
  #
  
  # Method called by Gosu.
  #
  def draw
    draw_background
    draw_ambient
    draw_objects
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
  # Draw the things.
  #
  def draw_objects
    @objects.draw
  end
  #
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