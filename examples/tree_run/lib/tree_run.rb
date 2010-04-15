class TreeRun < GameWindow
  
  # debug
  
  puts <<-MANUAL
    Both Players:
      Space - Revive the players and continue
    
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
           Gosu::Button::KbSpace  => :revive
  
  width  1000
  height 600
  
  caption "Tree Run - A Suicidal Freeski Undertaking"
  background Gosu::Color::WHITE
  
  damping 0.5
  gravity 0
  
  collision :player
  collision :player, :obstacle do |player, obstacle|
    obstacle.destroy!
    player.slam!
  end
  
  attr_accessor :steepness, :tree_density
  
  # Callbacks
  #
  def setup_players
    player1 = Skier.new self
    player1.name = "Player 1"
    player1.controls(Gosu::Button::KbA => Moveable.left(2),
                      Gosu::Button::KbD => Moveable.right(2),
                      Gosu::Button::KbS => Moveable::Down,
                      Gosu::Button::KbW => Moveable::Up)
    player1.warp_to width/3, height/3
    player1.image_from 'skier/red.png'
    player1.ui 20, 10, Gosu::Color::RED do "#{points.to_i} points" end
    
    player2 = Skier.new self
    player2.name = "Player 2"
    player2.controls(Gosu::Button::KbJ => Moveable.left(2),
                      Gosu::Button::KbL => Moveable.right(2),
                      Gosu::Button::KbK => Moveable::Down,
                      Gosu::Button::KbI => Moveable::Up)
    player2.warp_to width-width/3, height/3
    player2.image_from 'skier/violet.png'
    player2.ui width-120, 10, Gosu::Color.new(238,130,238) do "#{points.to_i} points" end
    
    @players = [player1, player2]
    @players.each &:show
  end
  def after_setup
    self.steepness    = 0.3
    self.tree_density = 0.01
  end
  def step
    factor = @players.map { |p| p.position.y }.max / height
    self.steepness    = 0.3  +   2*factor
    self.tree_density = 0.01 + 0.1*factor
    
    @players.each &:add_points
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
  
  # Revive both players, then proceed.
  #
  def revive
    @players.each &:revive
    proceed
  end
  
  # Tree Run methods.
  #
  def game_over?
    @players.any? &:destroyed?
  end
  def winner
    @players.sort_by(&:points).last
  end
  def display_end_message
    self.font.draw "Game Over - #{winner.name} won!", window.width/2-120, 10, Layer::UI, 1.0, 1.0, 0xff000000
  end
  def create_trees
    return unless rand > 1 - tree_density
    
    add Tree, rand(width), height
  end
  
end