class Player < Thing
  
  it_has UserInterface
  it_is Controllable # to steer
  it_is_a Pod        # to attach weapons
  
  it_has Lives
  lives 5
  
  it_has Hitpoints
  hitpoints 100
  
  layer Layer::Players
  
  shape :poly, [CP::Vec2.new(-16,-9), CP::Vec2.new(-16,9), CP::Vec2.new(16,9), CP::Vec2.new(16,-9)]
  mass 100
  moment 100
  friction 0
  rotation -Rotation::Quarter
  
  collision_type :player
  
  def shoot
    self.attachments.first.shoot
  end
  
  def reset
    warp = attach Warp.new(window), 0, 0
    threaded 20 do
      detach warp
    end
    self.position = CP::Vec2.new *window.uniform_random_position
    self.speed    = CP::Vec2.new 0, 0
  end
  
  def killed
    reset
  end
  
  def move
    obey_gravity
    bounce_off_border_x
    stop_on_bottom_border_y
  end
  def stop_on_bottom_border_y
    if position.y > window.screen_height - 8
      shape.body.v.y = 0
    end
  end
  def jump force = 30
    sometimes :jump, 50 do
      self.speed += CP::Vec2.new(0, -force)
    end
  end
  
end