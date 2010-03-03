# This game will have multiple Players in the form of a ship.
#
class Player < Moveable
  
  it_is_a Turnable, Shooter
  it_is Targetable
  include Lives
  
  # attr_accessor :score
  
  lives 10
  image 'player.png'
  
  shape :circle
  radius 5.0
  mass 0.1
  moment 0.1
  friction 1.0
  rotation -Math::PI
  # turn_speed 0.5 # turns per second
  
  collision_type :player
  
  frequency 20
  shoots Bullet
  
  muzzle_position { self.position }
  muzzle_velocity { |_| self.position.normalize } #(self.position - self.muzzle_position[]).normalize } # TODO
  muzzle_rotation { |_| self.rotation }
  
  # Move to moveable.
  #
  def accelerate
    self.speed = self.rotation_vector * 5
  end
  
  # controls do
  #
  
  # alternative_controls do
  #
  
  # def initialize window, color = 0x99ff0000
  #   super window
  #   
  #   # @font = window.font
  #   # @color = color
  #   
  #   # @score = 0
  #   # @projectile_loaded = true
  #   
  #   # @image = Gosu::Image.new window, "media/spaceship.png", false
  #   # @shape = CP::Shape::Circle.new CP::Body.new(0.1, 0.1), 5.0, CP::Vec2.new(0, 0)
  #   # 
  #   # self.friction = 1.0
  #   # self.rotation = -Math::PI
  #   
  #   # @shape.collision_type = :ship
  #   
  #   # self.shoots Projectile
  #   # self.muzzle_position_func { self.position + self.direction_to_earth * 20 }
  #   # self.muzzle_velocity_func { |target| self.direction_to_earth }
  #   # self.muzzle_rotation_func { self.rotation }
  #   # self.frequency = 20
  # end
  
  # def revive
  #   window.revive self
  # end
  
  # def colorize red, green, blue
  #   @color.red = red
  #   @color.green = green
  #   @color.blue = blue
  # end
  
  # Wrap to the other side of the screen when we fly off the edge.
  #
  def move
    if position.x > window.screen_width || position.x < 0
      @shape.body.v.x = -@shape.body.v.x
    end
    if position.y > window.screen_height || position.y < 0
      @shape.body.v.y = -@shape.body.v.y
    end
  end
  
  # def draw
  #   @font.draw "P1 Score: #{score}", 10, 10, ZOrder::UI, 1.0, 1.0, @color
  #   @font.draw "#{torque.round}", position.x - 10, position.y + 10, ZOrder::UI, 0.5, 0.5, @color
  #   @font.draw "#{speed.length.round}", position.x + 10, position.y + 10, ZOrder::UI, 0.5, 0.5, @color
  #   @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation
  # end
  
end