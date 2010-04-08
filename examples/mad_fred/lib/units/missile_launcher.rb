class MissileLauncher < Thing
  
  layer Layer::Players
  
  sequenced_image 'missile_launcher.png', 34, 19
  
  shape :circle
  radius 10.0
  mass 100
  moment 0.1
  friction 0
  rotation -Math::PI/2
  
  collision_type :player
  
  it_is Controllable
  controls Gosu::Button::KbSpace => Shooter::Shoot
  
  it_is_a Shooter
  # range 10
  frequency 0.05
  shoots Missile # or: Bullet
  muzzle_position { self.position + self.rotation_vector*self.radius }
  muzzle_velocity { |*| self.rotation_vector*10 }
  muzzle_rotation { |*| self.rotation+Math::PI/3 }
  
end