# This game will have multiple Players in the form of a ship.
#
class Spaceship < Thing
  
  it_is_a Turnable, Shooter, Controllable, Generator
  it_is Targetable
  it_has Lives, Hitpoints, UserInterface
  
  ui 10, 10, 0xff0000ff do "Spaceship: #{lives} lives" end
  
  generates Smoke, :every => 10, :until => 100
  
  # Thing
  #
  image 'spaceship/image.png'
  
  # Lives, Hitpoints
  #
  lives 5
  hitpoints 1_000
  
  #
  #
  shape :circle, 10.0
  friction 100.0       # TODO Remove these
  rotation -Math::PI/2 # TODO Remove these
  
  # TODO
  #
  # acceleration
  # top_speed
  #
  
  # Turnable
  #
  turn_speed 1 # turns per second
  
  collision_type :player
  
  # Shooter
  #
  range 10
  frequency 1
  shoots Missile # or: Bullet
  muzzle_position { self.position + self.rotation_vector*self.radius*2 }
  muzzle_velocity { |*| self.rotation_vector*10 }
  # muzzle_rotation { |*| self.rotation }
  
  # Pod
  #
  # Example: You can attach a Tank if you want.
  #
  # it_is_a Pod
  # attach Tank, 0, 50
  # attach Tank, 0, 25
  # attach Tank, 0, -25
  # attach Tank, 0, -50
  
  # Controllable
  #
  controls Gosu::Button::KbA => Turnable::Left,
           Gosu::Button::KbD => Turnable::Right,
           Gosu::Button::KbW => Moveable::Accelerate,
           Gosu::Button::KbS => Moveable::Backwards,
           Gosu::Button::KbSpace => Shooter::Shoot
  
  #
  #
  def move
    obey_gravity
    on_hitting_y { kill! }
    bounce_off_border_y # a helper method that makes the player bounce off the walls 100% elastically
    wrap_around_border_x # a helper method that makes the player wrap around the border
  end
  
  # Smoke on accelerating.
  #
  def accelerate *args
    super *args
    sometimes :accelerating, 20 do
      generate Smoke
    end
  end
  
  # Generates a number of explosions and debris when destroyed!
  #
  def destroyed!
    explosion = SmallExplosion.new window
    explosion.warp position + random_vector(rand(20))
    window.register explosion
    5.times do
      debris = generate Debris
      debris.speed = random_vector 10
    end
  end
  
  # def hit!
  #   start_generating # smokes
  # end
  
  def killed!
    start_generating
    # For fun:
    # Needs it_is_a Pod though
    #attach Tank.new(window), 0, rand(100)+20
  end
  
end