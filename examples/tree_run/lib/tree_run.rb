class TreeRun < GameWindow
  
  puts <<-MANUAL
    Player 1:
      A - turn left
      D - turn right
      S - accelerate
      W - brake
      E - jump (hopefully)
    
    Player 2:
      J - turn left
      L - turn right
      K - accelerate
      I - brake
      O - jump (hopefully)
      
    ESC - exit game
    
    Ride hard! Ride free! Respect nature :)
  MANUAL
  
  it_is Controllable
  controls Gosu::Button::KbEscape => :close,
           Gosu::Button::KbSpace  => :show_menu
  
  width  1000
  height 600
  # full_screen
  
  caption "Tree Run - A Suicidal Freeski Undertaking"
  background 'background.png', :hard_borders => false
  
  damping 0.5
  gravity 0.0
  
  collisions do
    add_collision_func :ambient, :ambient, &nil
    add_collision_func :ambient, :obstacle, &nil
    add_collision_func :ambient, :player, &nil
    # add_collision_func :player, :player
    add_collision_func :player, :obstacle do |player_shape, obstacle_shape|
      window.moveables.each do |movable|
        if movable.shape == player_shape
          movable.slam!
        end
      end
    end
  end
  
  def setup_players
    # player 1
    @player1 = Skier.new(self)
    @player1.name = "Player 1"
    @controls << Control.new(self, @player1,
      Gosu::Button::KbA => Moveable.left(2),
      Gosu::Button::KbD => Moveable.right(2),
      Gosu::Button::KbS => Moveable::Down,
      Gosu::Button::KbW => Moveable::Up)
    @player1.warp_to window.width/3, window.height/3
    @players << @player1
    
    # player 2
    @player2 = Skier.new(self)
    @player2.name = "Player 2"
    @controls << Control.new(self, @player2,
      Gosu::Button::KbJ => Moveable.left(2),
      Gosu::Button::KbL => Moveable.right(2),
      Gosu::Button::KbK => Moveable::Down,
      Gosu::Button::KbI => Moveable::Up)
    @player2.warp_to window.width-window.width/3, window.height/3
    @players << @player2
    
    @players.each {|p| register p}
    super
  end
  
  attr_accessor :steepness, :tree_density
  
  def setup_environment
    start_game
    super
  end
  
  def next_step
    
    display_points
    
    # game end
    if game_over?
      stop_game
      display_end_message
    else
      # speed and stuff
      proceed_game
    
      # trees
      create_trees
    end
    
    super
  end
  
  def game_over?
    @players.any?(&:destroyed?)
  end
  
  def start_game
    self.steepness    = 0.3
    self.tree_density = 0.01
  end
  
  def stop_game
    self.steepness    = 0
    self.tree_density = 0
  end
  
  def proceed_game
    factor = @players.map {|p| p.position.y}.max / height
    self.steepness    = 0.3  + 2*factor
    self.tree_density = 0.01 + 0.1*factor
    
    @players.each(&:add_points)
  end
  
  def winner
    return unless game_over?
    @players.sort_by(&:points).last
  end
  
  def display_end_message
    self.font.draw "Game Over - #{winner.name} won!", window.width/2-120, 10, Layer::UI, 1.0, 1.0, 0xff000000
    
    @should_quit ||= 0; @should_quit += 1
    if @should_quit > 300
      close
    end
  end
  
  def display_points
    self.font.draw "#{@player1.points.to_i} points", 20, 10, Layer::UI, 1.0, 1.0, 0xff000000
    self.font.draw "#{@player2.points.to_i} points", window.width-120, 10, Layer::UI, 1.0, 1.0, 0xff000000
  end

  def create_trees
    return unless rand > 1 - tree_density
    
    tree = Tree.new self
    tree.warp_to rand(window.width), window.height
    window.register tree
  end
  
end