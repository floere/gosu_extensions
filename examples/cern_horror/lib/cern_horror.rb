class CernHorror < GameWindow
  
  default_controls
  
  size 876, 516
  
  caption "CERN HORROR"
  background 'background.png'
  
  damping 0.001
  gravity 1
  
  collision :player
  collision :player, :black_hole do |player, black_hole|
    player.destroy!
  end
  
  def setup_players
    @player1 = randomly_add Player
    @player1.controls(Gosu::Button::KbA => Moveable.left(0.2),
                      Gosu::Button::KbD => Moveable.right(0.2),
                      Gosu::Button::KbS => Moveable.down(0.2),
                      Gosu::Button::KbW => Moveable.up(0.2))
    @player1.image_from 'player1.png'
    @player1.ui 10, 10, Gosu::Color.new(255,255,255) do "UI PLAYER 1" end
      
    @player2 = randomly_add Player
    @player2.controls(Gosu::Button::KbJ => Moveable.left(0.2),
                      Gosu::Button::KbL => Moveable.right(0.2),
                      Gosu::Button::KbI => Moveable.down(0.2),
                      Gosu::Button::KbK => Moveable.up(0.2))
    @player2.image_from 'player2.png'
    @player2.ui width-120, 10, Gosu::Color.new(255,255,255) do "UI PLAYER 2" end
    
    @black_hole = add BlackHole, width/2, height/2
  end
  
  def gravity_vector_for thing
    vector = @black_hole.position - thing.position
    vector / SUBSTEPS
  end
  
end