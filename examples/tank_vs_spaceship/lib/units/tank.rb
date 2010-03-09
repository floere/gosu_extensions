# This game will have multiple Players in the form of a ship.
#
class Tank < Moveable
  
  it_is_a Shooter, Controllable, Generator #, Pod.manual!
  it_is Targetable
  include Lives
  
  # Thing
  #
  image 'tank.png'
  
  # Pod
  #
  # attach Missile, 30, 30
  
  # Lives
  #
  lives 3
  
  #
  #
  shape :circle
  radius 10.0
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
  
  # Shooter
  #
  range 10
  frequency 1
  shoots Missile # Bullet
  muzzle_position { self.position + self.rotation_vector*self.radius*2 }
  muzzle_velocity { |*| self.rotation_vector*10 }
  # muzzle_rotation { |*| self.rotation }
  
  # Controllable
  #
  controls Gosu::Button::KbLeft => Moveable::Left,
           Gosu::Button::KbRight => Moveable::Right,
           Gosu::Button::KbUp => Shooter::Shoot,
           Gosu::Button::KbDown => :righten
  
  #
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
  
  def kill!
    super
    @ui = ["Tank hit!: #{lives} lives remain.", window.width-220, 10, Layer::UI, 1.0, 1.0, 0xffff0000]
  end
  
  def draw_ui
    window.font.draw *@ui if @ui
  end
  
end