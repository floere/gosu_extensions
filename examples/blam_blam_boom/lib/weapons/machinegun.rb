class Machinegun < Sprite
  
  it_is Turnable
  turn_speed 0.5
  
  image 'machinegun.png'
  
  rotation -Rotation::Eight
  
  it_is Controllable
    controls Gosu::Button::KbA => Turnable::Left,
             Gosu::Button::KbS => Turnable::Right,
             Gosu::Button::KbQ => Shooter::Shoot
  
  it_is_a Shooter
    frequency 5
    shoots Bullet
    muzzle_position Shooter::Position.front(10)
    muzzle_velocity Shooter::Velocity.front(5)
  
end