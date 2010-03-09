#
#
class Bullet < ShortLived
  
  it_is_a Shot
  
  lifetime { 100 + rand(50) }
  image 'bullet.png'
  shape :circle
  radius 1.0
  mass 0.05
  moment 0.1
  collision_type :projectile
  friction 0
  velocity { 20 + rand }
  layer Layer::Players
  plays 'bullet.wav', 'bullet.mp3'
  
  # def initialize window
  #   self.lifetime = 200 + rand(100)
  #   
  #   super window
  #   
  #   @image = Gosu::Image.new window, "media/bullet.png", false
  #   
  #   @shape = CP::Shape::Circle.new(CP::Body.new(0.1, 0.1),
  #                                  1.0,
  #                                  CP::Vec2.new(0.0, 0.0))
  #   @shape.collision_type = :projectile
  #   
  #   self.friction = 0.0001
  #   self.velocity = 6 + rand(2)
  #   
  #   # @sound = Gosu::Sample.new window, 'media/sounds/cannon-02.wav'
  #   # @sound.play
  # end
  
  # def destroy!
  #   explosion = SmallExplosion.new window
  #   explosion.warp position
  #   window.register explosion
  #   super
  # end
  
  def move
    obey_gravity
    on_hitting_y { destroy! }
    # bounce_off_border_y # a helper method that makes the player bounce off the walls 100% elastically
    wrap_around_border_x # a helper method that makes the player wrap around the border
  end
  
  # def draw
  #   @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation
  # end
  
end