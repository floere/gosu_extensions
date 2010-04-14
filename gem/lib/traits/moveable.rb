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
  
end