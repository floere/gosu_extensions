class Machinegun < Thing
  
  it_is Turnable
  turn_speed 0.5
  
  layer Layer::Players
  
  image 'machinegun.png'
  
  shape :circle
  radius 10.0
  mass 100
  moment 0.1
  friction 0
  rotation -Math::PI/3
  
  collision_type :player
  
  it_is Controllable
  controls Gosu::Button::KbA => Turnable::Left,
           Gosu::Button::KbS => Turnable::Right,
           Gosu::Button::KbQ => Shooter::Shoot
  
  it_is_a Shooter
  range 1000
  frequency 5
  shoots Bullet
  muzzle_position { self.position + self.rotation_vector*self.radius }
  muzzle_velocity { |*| self.rotation_vector*5 }
  
end