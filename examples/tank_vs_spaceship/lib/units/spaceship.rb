# This game will have multiple Players in the form of a ship.
#
class Spaceship < Thing
  
  it_is_a Generator
  it_is Targetable
  
  it_has UserInterface
  ui 10, 10, 0xff0000ff do "Spaceship: #{lives} lives" end
  
  generates Smoke, :every => 10, :until => 100
  
  image 'spaceship/image.png'
  
  it_has Lives
  lives 1
  # it_has Hitpoints
  # hitpoints 1_000
  
  # shape :poly, [CP::Vec2.new(0, 10), CP::Vec2.new(-6, -3), CP::Vec2.new(6, -3)]
  shape :circle, 12
  moment 1
  friction 100                # TODO Remove these
  rotation -Rotation::Quarter # TODO Remove these
  
  collision_type :player
  
  it_is Turnable
  turn_speed 1 # turns per second
  
  it_is_a Shooter
  range 10
  frequency 1
  shoots Missile # or: Bullet, for example
  muzzle_position Shooter::Position.front(20)
  muzzle_velocity Shooter::Velocity.front(10)
  # muzzle_rotation { |*| self.rotation }
  
  # Example: You can attach a Tank if you want.
  #
  # it_is_a Pod
  # attach Tank, 0, 50
  # attach Tank, 0, 25
  # attach Tank, 0, -25
  # attach Tank, 0, -50
  
  it_is_a Controllable
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
    bounce_off_border_y
    wrap_around_border_x
  end
  
  # Smoke on accelerating.
  #
  def accelerate *args
    super *args
    sometimes(:accelerating, 10) { generate Smoke } if current_speed < 20
  end
  
  # Generates a number of explosions and debris when destroyed!
  #
  def destroyed!
    30.times do
      explosion = generate SmallExplosion
      explosion.position += random_vector(rand(7))
      explosion.speed += random_vector(rand(20))
    end
    8.times do
      debris = generate(Debris)
      debris.speed  = self.speed*rand + random_vector(rand(15))
      debris.torque = rand(5)
    end
  end
  
  # def hit!
  #   start_generating # smokes
  # end
  
  def killed!
    start_generating
    # For fun:
    # Needs it_is_a Pod though
    # attach Smoke.new(window), 0, rand(100)+20
  end
  
end