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
  background 'background.png'
  
  damping 0.5
  gravity 0.0
  
  no_collision :ambient # no collisions between ambients
  no_collision :ambient, :obstacle
  no_collision :ambient, :player
  collision(:player, :obstacle) { slam! } # slam!s the player
  collision :player # players do collide - you can also omit this, it will work
  # collision :player, :player do |player1, player2| # they will collide
  #   # do something with player 1
  #   # do something with player 2
  # end
  
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
  
  def after_setup
    self.steepness    = 0.3
    self.tree_density = 0.01
  end
  
  def step
    display_points
    factor = @players.map { |p| p.position.y }.max / height
    self.steepness    = 0.3  + 2*factor
    self.tree_density = 0.01 + 0.1*factor
    
    @players.each(&:add_points)
    create_trees
  end
  
  # Stopping condition
  #
  stop_on { game_over? }
  
  def after_stopping
    self.steepness    = 0
    self.tree_density = 0
    display_end_message
  end
  
  def game_over?
    @players.any?(&:destroyed?)
  end
  
  def winner
    return unless game_over?
    @players.sort_by(&:points).last
  end
  
  def display_end_message
    self.font.draw "Game Over - #{winner.name} won!", window.width/2-120, 10, Layer::UI, 1.0, 1.0, 0xff000000
    
    after(300) { close }
  end
  
  # Metaprogram.
  #
  def display_points
    self.font.draw "#{@player1.points.to_i} points", 20, 10, Layer::UI, 1.0, 1.0, 0xff000000
    self.font.draw "#{@player2.points.to_i} points", window.width-120, 10, Layer::UI, 1.0, 1.0, 0xff000000
  end

  def create_trees
    return unless rand > 1 - tree_density
    
    add Tree, rand(width), height
  end
  
end