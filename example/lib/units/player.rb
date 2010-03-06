# This game will have multiple Players in the form of a ship.
#
class Player < Moveable
  
  it_is_a Turnable, Shooter, Controllable #, Pod.manual!
  it_is Targetable
  include Lives
  
  # Thing
  #
  image 'player.png'
  
  # Pod
  #
  # attach Missile, 30, 30
  
  # Lives
  #
  lives 10
  
  #
  #
  shape :circle
  radius 5.0
  mass 0.1
  moment 0.1
  friction 100.0
  rotation -Math::PI
  
  #
  #
  # acceleration
  # top_speed
  #
  
  # Turnable
  #
  turn_speed 0.5 # turns per second
  
  collision_type :player
  
  # Shooter
  #
  range 10
  frequency 2
  shoots Missile # Bullet
  muzzle_position { self.position + self.rotation_vector.normalize*self.radius }
  muzzle_velocity { |_| self.rotation_vector.normalize*10 + self.random_vector*rand/10 }
  muzzle_rotation { |_| self.rotation }
  
  # Controllable
  #
  controls Gosu::Button::KbA => Turnable::Left,
           Gosu::Button::KbD => Turnable::Right,
           Gosu::Button::KbW => :accelerate,
           # Gosu::Button::KbS => :reverse,
           # Gosu::Button::Kb1 => :revive
           Gosu::Button::KbSpace => :shoot
  
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
  
  #
  #
  def move
    # obey_gravity
    bounce_off_border_y # a helper method that makes the player bounce off the walls 100% elastically
    wrap_around_border_x # a helper method that makes the player wrap around the border
  end
  
  # def draw
  #   @font.draw "P1 Score: #{score}", 10, 10, ZOrder::UI, 1.0, 1.0, @color
  #   @font.draw "#{torque.round}", position.x - 10, position.y + 10, ZOrder::UI, 0.5, 0.5, @color
  #   @font.draw "#{speed.length.round}", position.x + 10, position.y + 10, ZOrder::UI, 0.5, 0.5, @color
  #   @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation
  # end
  
end