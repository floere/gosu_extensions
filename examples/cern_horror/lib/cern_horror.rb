class CernHorror < GameWindow
  
  default_controls
  
  size 876, 516
  
  caption "CERN HORROR"
  background #'background.png'
  
  damping 0.01
  gravity 1
  
  collision :player
  collision :player, :debris
  collision :baby, :debris
  
  collision :player, :black_hole do |player, _|
    player.destroy!
  end
  
  collision :debris, :black_hole do |debris, _|
    debris.destroy!
  end
  collision :baby, :black_hole do |baby, black_hole|
    baby.destroy!
    black_hole.baby_consumed
  end
  
  def setup_players
    @player1 = add Player, 0, rand(height)
    @player1.controls(Gosu::Button::KbA => Moveable.left(0.2),
                      Gosu::Button::KbD => Moveable.right(0.2),
                      Gosu::Button::KbS => Moveable.down(0.2),
                      Gosu::Button::KbW => Moveable.up(0.2))
    @player1.image_from 'player1.png'
    @player1.ui 10, height-30, Gosu::Color.new(0,0,0) do
      destroyed? ? "DEAD" : "P1: #{souls_saved}"
    end
      
    @player2 = add Player, width, rand(height)
    @player2.controls(Gosu::Button::KbLeft  => Moveable.left(0.2),
                      Gosu::Button::KbRight => Moveable.right(0.2),
                      Gosu::Button::KbUp    => Moveable.down(0.2),
                      Gosu::Button::KbDown  => Moveable.up(0.2))
    @player2.image_from 'player2.png'
    @player2.ui width-60, height-30, Gosu::Color.new(0,0,0) do
      destroyed? ? "DEAD" : "P2: #{souls_saved}"
    end
    
    @player3 = add Player, rand(width), 0
    @player3.controls(Gosu::Button::KbJ => Moveable.left(0.2),
                      Gosu::Button::KbL => Moveable.right(0.2),
                      Gosu::Button::KbI => Moveable.down(0.2),
                      Gosu::Button::KbK => Moveable.up(0.2))
    @player3.image_from 'player3.png'
    @player3.ui width/2-20, 10, Gosu::Color.new(0,0,0) do
      destroyed? ? "DEAD" : "P3: #{souls_saved}"
    end
    
    @black_hole = add BlackHole, width/2, height/2
    @black_hole.ui width/2, height-50, Gosu::Color.new(0,0,0) do souls_needed end
  end
  
  def gravity_vector_for thing
    vector = @black_hole.position - thing.position
    vector / SUBSTEPS
  end
  
  def step
    end_game if @black_hole.finished?
    create_debris
  end
  
  def end_game
    p "YOU FAILED"
    exit
  end
  
  def create_debris
    event_number = rand
    if event_number > 0.98
      # debris = randomly_add Sofa
      debris = add Sofa, rand(width), 0
      debris.speed = gravity_vector_for(debris).rotate(-(Math::PI/2).radians_to_vec2)
    end
    if event_number < 0.01
      # baby = randomly_add Baby
      baby = add Baby, rand(width), height
      baby.speed = gravity_vector_for(baby).rotate(-(Math::PI/2).radians_to_vec2)/2
    end
  end
  
end