class TankVsSpaceship < GameWindow
  
  # debug
  
  puts <<-MANUAL
    Spaceship:
      A - turn left
      W - accelerate
      D - turn right
      Space - Shoot
    
    Tank:
      Left Arrow - left
      Up Arrow - shoot
      Right Arrow - right
      Down Arrow - let engineers righten the tank (important after hit!)
      
    ESC - exit game
    
    Have fun!
  MANUAL
  
  it_is Controllable
    controls Gosu::Button::KbEscape => :close,
             Gosu::Button::Kb6      => :revive,
             Gosu::Button::Kb9      => :slower,
             Gosu::Button::Kb0      => :faster
  
  width  1022
  height  595
  # full_screen # comment if you want a windowed app.
  caption "Incredible Space Battles!"
  
  # font Gosu::default_font_name, 20
  
  background 'space.png'
  
  damping 0.1
  gravity 0.2
  
  no_collision :projectile
  no_collision :projectile, :ambient
  collision :player, :projectile do |player, projectile|
    projectile.destroy!
    player.kill!
    player.draw_ui
  end
  
  # Overridden, called in the setup.
  #
  def setup_players
    @players = []
    @players << add(Spaceship, 400, 320)
    @players << add(Tank, width/2, height-100)
  end
  def revive
    @players.each &:revive
  end
  
  # As an example.
  #
  def setup_waves
    # Generates 20 Tanks, randomly, at time 100
    #
    # @waves.add 100, Tank, 5
    
    # Generates 20 Tanks, at the top border, at time 100, inside the game field by 100px
    #
    # @waves.add 150, Tank, 5, &Wave.top_border(-100)
  end
  
end