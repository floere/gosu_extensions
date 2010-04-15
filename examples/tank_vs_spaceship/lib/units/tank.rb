# This game will have multiple Players in the form of a ship.
#
class Tank < Thing
  
  it_is_a Generator
  it_is Targetable
  
  it_has UserInterface
    ui 900, 10, 0xffff0000 do "Tank: #{lives} lives" end
  
  # Thing
  #
  image 'tank/image.png'
  
  it_is_a Shooter
    range 10
    frequency 1
    shoots Bullet
    muzzle_position Shooter::Position.front(22)
    muzzle_velocity Shooter::Velocity.front(5)
    # muzzle_rotation { |*| self.rotation }
  
  it_is Controllable
    controls Gosu::Button::KbLeft => Moveable::Left,
             Gosu::Button::KbRight => Moveable::Right,
             Gosu::Button::KbUp => Shooter::Shoot,
             Gosu::Button::KbDown => :righten
  
  it_has Lives
    lives 3
  
  #
  #
  shape :circle, 11.0
  moment 1
  friction 100
  rotation -::Rotation::Quarter
  
  collision_type :player
  
  # Overridden.
  #
  def move
    obey_gravity
    bounce_off_border_y # a helper method that makes the player bounce off the walls 100% elastically
    wrap_around_border_x # a helper method that makes the player wrap around the border
  end
  
  # 
  #
  def righten
    # Play a rightening sound if the tank is not upright.
    #
    unless @righten_sound || upright?
      @righten_sound = Gosu::Sample.new self.window, File.join(Resources.root, 'tank/righten.mp3')
      @righten_sound.play 0.2
    end
    self.rotation += (self.rotation + Math::PI/2) % (2*Math::PI)/5_000
  end
  
  #
  #
  def upright?
    self.rotation.close_to? 4.71, 0.01
  end
  
  # Generates a number of explosions when destroyed!
  #
  def destroyed!
    30.times do
      explosion = generate SmallExplosion
      explosion.position += random_vector(rand(40))
      explosion.speed += random_vector(rand(20))
    end
  end
  
end