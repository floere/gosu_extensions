class Jeep < Thing
  
  layer Layer::Players
  
  sequenced_image 'jeep.png', 65, 43
  
  shape :circle
  radius 21.0
  mass 500
  moment 0.1
  friction 10.0
  rotation -Math::PI/2
  
  collision_type :player
  
  it_is Controllable
  controls Gosu::Button::KbLeft  => Moveable::Left,
           Gosu::Button::KbRight => Moveable::Right,
           Gosu::Button::KbUp    => :jump
  
  it_is_a Pod
  attach MissileLauncher, 22, 0
  
  def move
    obey_gravity
    bounce_off_bottom_border_y
  end
  def bounce_off_bottom_border_y
    if position.y > window.screen_height - 21
      shape.body.v.y = -shape.body.v.y.to_f
    end
  end
  def jump
    self.speed += CP::Vec2.new(0, -30) if self.position.y > (window.height - 21)
  end
  
end