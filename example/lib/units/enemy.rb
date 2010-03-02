# An enemy moves towards the players.
#
class Enemy < Moveable
  
  include Lives
  it_is Targetable
  
  lives 10
  image 'enemy.png', 22, 22
  sequenced_image
  shape :circle
  radius 11.0
  mass 1.0
  moment 1.0
  collision_type :enemy
  rotation -Math::PI/2
  layer Layer::Players
  
  # draw_image { Gosu::milliseconds / 100 % @image.size }
  
  def initialize window
    super window
    
    # @image = Gosu::Image::load_tiles window, "media/spaceship.png", 22, 22, false
    # 
    # @shape = CP::Shape::Circle.new CP::Body.new(1.0, 1.0), 11.0, CP::Vec2.new(0, 0)
    # @shape.collision_type = :enemy
    # 
    # self.rotation = -Math::PI/2
    
    after_initialize
  end
  
  def validate_position
    # self.position -= horizontal / 20
  end
  
  # def draw
  #   image = @image[Gosu::milliseconds / 100 % @image.size];
  #   image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  # end
end