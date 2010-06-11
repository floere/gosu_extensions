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
  
  collision :player, :baby do |player, baby|
    baby.destroy!
    player.save_soul
  end
  
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
    @black_hole = add BlackHole, width/2, height/2
    @black_hole.ui width/2, height-50, Gosu::Color.new(0,0,0) do souls_needed end
    
    steering_strength = 0.3
    
    @player1 = add Player, 10, rand(height)
    @player1.controls(Gosu::Button::KbA => Moveable.left(steering_strength),
                      Gosu::Button::KbD => Moveable.right(steering_strength),
                      Gosu::Button::KbS => Moveable.down(steering_strength),
                      Gosu::Button::KbW => Moveable.up(steering_strength))
    @player1.image_from 'player1.png'
    @player1.ui 10, height-30, Gosu::Color.new(0,0,0) do
      destroyed? ? "DEAD" : "P1: #{souls_saved}"
    end
      
    @player2 = add Player, width-10, rand(height)
    @player2.controls(Gosu::Button::KbLeft  => Moveable.left(steering_strength),
                      Gosu::Button::KbRight => Moveable.right(steering_strength),
                      Gosu::Button::KbUp    => Moveable.down(steering_strength),
                      Gosu::Button::KbDown  => Moveable.up(steering_strength))
    @player2.image_from 'player2.png'
    @player2.ui width-60, height-30, Gosu::Color.new(0,0,0) do
      destroyed? ? "DEAD" : "P2: #{souls_saved}"
    end
    
    @player3 = add Player, rand(width), 10
    @player3.controls(Gosu::Button::KbJ => Moveable.left(steering_strength),
                      Gosu::Button::KbL => Moveable.right(steering_strength),
                      Gosu::Button::KbI => Moveable.down(steering_strength),
                      Gosu::Button::KbK => Moveable.up(steering_strength))
    @player3.image_from 'player3.png'
    @player3.ui width/2-20, 10, Gosu::Color.new(0,0,0) do
      destroyed? ? "DEAD" : "P3: #{souls_saved}"
    end
    
    # Make the players rotate in the beginning. Opposite all the debris.
    #
    @players = [@player1, @player2, @player3]
    @players.each do |player|
      player.speed = gravity_vector_for(player).rotate((Math::PI/2).radians_to_vec2)/5
    end
  end
  
  def gravity_vector_for thing
    vector = @black_hole.position - thing.position
    vector / SUBSTEPS
  end
  
  def step
    end_game if end_game?
    create_debris
  end
  
  def end_game?
    @black_hole.finished? || @player1.destroyed? && @player2.destroyed? && @player3.destroyed?
  end
  def end_game
    p "YOU FAILED, THE BLACK HOLE HAS WON!"
    exit
  end
  
  def create_debris
    event_number = rand
    if event_number > 0.98
      # TODO improve
      if event_number > 0.99
        debris = add Chicken, rand(width), 0
        debris.speed = gravity_vector_for(debris).rotate(-(Math::PI/2).radians_to_vec2)
      else
        debris = add Sofa, rand(width), 0
        debris.speed = gravity_vector_for(debris).rotate(-(Math::PI/2).radians_to_vec2)
      end
    end
    if event_number < 0.01
      # baby = randomly_add Baby
      baby = add Baby, rand(width), height
      baby.speed = gravity_vector_for(baby).rotate(-(Math::PI/2).radians_to_vec2)/2
    end
  end
  
end