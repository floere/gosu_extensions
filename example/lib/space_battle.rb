class SpaceBattle < GameWindow
  
  width  1200
  height  700
  full_screen
  caption "Incredible Space Battles!"
  
  font Gosu::default_font_name, 20
  
  background 'media/space.png', :repeating => true
  damping 1.0
  
  collisions do
    add_collision_func :projectile, :projectile, &nil
    add_collision_func :projectile, :enemy do |projectile_shape, enemy_shape|
      # TODO
      #
      # destroy! projectile_shape
      #
      # def destroy! shape
      #   @moveables.each { |thing| thing.shape == shape && thing.destroy! }
      # end
      #
      @moveables.each { |projectile| projectile.shape == projectile_shape && projectile.destroy! }
    end
  end
  
end