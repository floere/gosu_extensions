# This game will have multiple Players in the form of a ship.
#
class Tank < Thing
  
  it_is_a Controllable, Generator#, Pod.manual!
  it_is Targetable
  
  # Thing
  #
  image 'tank.png'
  
  it_is_a Shooter do
    range 10
    frequency 1
    shoots Bullet
    muzzle_position { self.position + self.rotation_vector*self.radius*2 }
    muzzle_velocity { |*| self.rotation_vector*5 }
    # muzzle_rotation { |*| self.rotation }
  end
  
  it_is Controllable
  it_has Lives
  
  controls Gosu::Button::KbLeft => Moveable::Left,
           Gosu::Button::KbRight => Moveable::Right,
           Gosu::Button::KbUp => Shooter::Shoot,
           Gosu::Button::KbDown => :righten
  lives 3
  
  # Pod
  #
  # attach Missile, 30, 30
  
  #
  #
  shape :circle
  radius 11.0
  mass 0.1
  moment 0.1
  friction 100.0
  rotation -Math::PI/2
  
  # TODO
  #
  # acceleration
  # top_speed
  #
  
  # Turnable
  #
  # turn_speed 0.5 # turns per second
  
  collision_type :player
  
  # Overridden.
  #
  def move
    obey_gravity
    bounce_off_border_y # a helper method that makes the player bounce off the walls 100% elastically
    wrap_around_border_x # a helper method that makes the player wrap around the border
  end
  
  def righten
    self.rotation += (self.rotation + Math::PI/2) % (2*Math::PI)/5_000
  end
  
  # TODO explosive death
  #
  # Generates a number of explosions when destroyed!
  #
  def destroy!
    20.times do
      explosion = SmallExplosion.new window
      explosion.warp position + random_vector(rand(50))
      window.register explosion
    end
    super
  end
  
  def killed!
    @ui = ["Tank hit!: #{lives} lives remain.", window.width-220, 10, Layer::UI, 1.0, 1.0, 0xffff0000]
  end
  
  def draw_ui
    window.font.draw *@ui if @ui
  end
  
end