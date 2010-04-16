class Machinegun < Thing
  
  it_is Turnable
  turn_speed 0.5
  
  layer Layer::UI
  
  image 'machinegun.png'
  
  shape :circle, 4.0
  mass 85
  moment 0.1
  friction 1.0
  
  # rotation -Rotation::Quarter
  
  collision_type :weapon
  
  it_is_a Shooter
    frequency 20
    shoots Bullet
    muzzle_position Shooter::Position.front(10)
    muzzle_velocity Shooter::Velocity.front(5)
    muzzle_rotation { ::Rotation::Quarter }
  
end