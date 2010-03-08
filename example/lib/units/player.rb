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
  rotation -Math::PI/2
  
  # TODO
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
  
  #
  #
  def move
    obey_gravity
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