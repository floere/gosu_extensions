class Player < Thing
  
  it_is Controllable # to steer
  it_is_a Pod        # to attach weapons
  
  it_has Lives
  lives 5
  
  it_has Hitpoints
  hitpoints 100
  
  layer Layer::Players
  
  sequenced_image 'jeep.png', 65, 43
  
  shape :circle, 8.0
  mass 85
  moment 0.1
  friction 1.0
  rotation -Rotation::Quarter
  
  collision_type :player
  
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
  def jump
    sometimes :jump, 50 do
      self.speed += CP::Vec2.new(0, -30)
    end
  end
  
  def hit!
    
  end
  
  def kill!
    
  end
  
end