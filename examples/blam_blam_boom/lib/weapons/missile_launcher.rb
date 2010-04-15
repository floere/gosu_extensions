class MissileLauncher < Sprite
  
  layer Layer::Players
  
  sequenced_image 'missile_launcher.png', 34, 19
  
  rotation -Rotation::Quarter
  
  it_is Controllable
    controls Gosu::Button::KbSpace => Shooter::Shoot
  
  it_is_a Shooter
    frequency 0.1
    shoots Missile # or: Bullet
    muzzle_position { self.position }
    muzzle_velocity { |*| self.rotation_vector*10 }
    muzzle_rotation { |*| self.rotation+Math::PI/3 }
  
end