class SpaceBattle < GameWindow
  
  width  1022
  height  595
  # full_screen # comment if you want a windowed app.
  caption "Incredible Space Battles!"
  
  # font Gosu::default_font_name, 20
  
  background 'space.png', :hard_borders => false
  damping 0.1
  
  collisions do
    add_collision_func :projectile, :player, &nil
    add_collision_func :projectile, :enemy do |projectile_shape, enemy_shape|
      # TODO
      #
      # projectile_shape.destroy!
      #
      # def destroy!
      #   window.destroy! self # @moveables.each { |thing| thing.shape == shape && thing.destroy! }
      # end
      #
      @moveables.each { |projectile| projectile.shape == projectile_shape && projectile.destroy! }
    end
  end
  
  # Overridden, called in the setup.
  #
  def setup_players
    @player1 = Player.new self
    @player1.warp_to 400, 320
    
    add_controls_for @player1,
                     Gosu::Button::KbA => Turnable::Left,
                     Gosu::Button::KbD => Turnable::Right,
                     Gosu::Button::KbW => :accelerate,
                     # Gosu::Button::KbS => :reverse,
                     # Gosu::Button::Kb1 => :revive
                     Gosu::Button::KbSpace => :shoot
                     
    @players << @player1
    
    register @player1
  end
  
end