# A moveable has a shape, speed etc.
#
module Moveable extend Trait
  
  Accelerate = :accelerate; def self.accelerate strength = 1.0; [Accelerate, strength] end
  Left       = :move_left;  def self.left       strength = 1.0; [Left,       strength] end
  Right      = :move_right; def self.right      strength = 1.0; [Right,      strength] end
  Up         = :move_up;    def self.up         strength = 1.0; [Up,         strength] end
  Down       = :move_down;  def self.down       strength = 1.0; [Down,       strength] end
  Backwards  = :backwards;  def self.backwards  strength = 1.0; [Backwards,  strength] end
  
  # Default methods for controls.
  #
  def accelerate strength = 1.0
    self.speed += self.rotation_vector * strength/SUBSTEPS
  end
  def move_left strength = 1.0
    self.speed += CP::Vec2.new(-strength.to_f/SUBSTEPS, 0)
  end
  def move_right strength = 1.0
    self.speed += CP::Vec2.new(strength.to_f/SUBSTEPS, 0)
  end
  def move_up strength = 1.0
    self.speed += CP::Vec2.new(0, -strength.to_f/SUBSTEPS)
  end
  def move_down strength = 1.0
    self.speed += CP::Vec2.new(0, strength.to_f/SUBSTEPS)
  end
  def backwards strength = 1.0
    accelerate -0.5*strength
  end
  
  # Movement rules
  #
  # TODO Move to Sprite?
  #
  # Note: Call in method move.
  #
  def bounce_off_border_x elasticity = 1.0
    if position.x > window.screen_width || position.x < 0
      shape.body.v.x = -shape.body.v.x.to_f*elasticity
    end
  end
  def bounce_off_border_y elasticity = 1.0
    if position.y > window.screen_height || position.y < 0
      shape.body.v.y = -shape.body.v.y.to_f*elasticity
    end
  end
  def bounce_off_border elasticity = 1.0
    bounce_off_border_x elasticity
    bounce_off_border_y elasticity
  end
  def wrap_around_border_x
    if position.x > window.screen_width
      position.x -= window.screen_width
    elsif position.x < 0
      position.x += window.screen_width
    end
  end
  def wrap_around_border_y
    if position.y > window.screen_height
      position.y -= window.screen_height
    elsif position.y < 0
      position.y += window.screen_height
    end
  end
  def wrap_around_border
    wrap_around_border_x
    wrap_around_border_y
  end
  def obey_gravity
    self.speed += window.gravity_vector
  end
  def on_hitting_x
    yield if block_given? && position.x > window.screen_width || position.x < 0
  end
  def on_hitting_y
    yield if block_given? && position.y > window.screen_height || position.y < 0
  end
  def rotate_towards_velocity
    self.rotation = self.speed.to_angle
  end
  
end