class SpaceBattle < GameWindow
  
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
           Gosu::Button::KbP      => :show_menu
  
  width  1022
  height  595
  # full_screen # comment if you want a windowed app.
  caption "Incredible Space Battles!"
  
  # font Gosu::default_font_name, 20
  
  background 'space.png'
  
  damping 0.1
  gravity 0.2
  
  no_collision :ambient
  no_collision :ambient, :player
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
    @spaceship = Spaceship.new self
    @spaceship.warp_to 400, 320
    @players << @spaceship
    register @spaceship
    
    @tank = Tank.new self
    @tank.warp_to self.screen_width/2, self.screen_height
    @players << @tank
    register @tank
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