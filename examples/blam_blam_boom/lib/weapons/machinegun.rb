class Machinegun < Thing
  
  it_is_a Generator
  
  layer Layer::UI
  
  image 'machinegun.png'
  
  shape :circle, 4.0
  mass 85
  moment 0.1
  friction 1.0
  
  rotation Rotation::Half
  
  collision_type :weapon
  
  it_is_a Shooter
    frequency 8
    shoots Bullet
    muzzle_position Shooter::Position.front(15)
    muzzle_velocity Shooter::Velocity.front(3)
    muzzle_rotation { 0 }
    
  def shoot
    if super
      shell = generate Shell
      shell.speed = self.rotation_vector.rotate(CP::Vec2.new(0,-20+2*rand))
      shell.torque = rand*0.1
    end
  end
  
end