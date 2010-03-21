#
class Missile < Thing
  
  it_is ShortLived
  it_is_a Shot
  it_is_a Generator
  generates Smoke, :starting_at => 10, :every => 10, :until => 100
  
  lifetime { 100 + rand(100) }
  image 'missile/image.png'
  shape :circle
  radius 1.0
  mass 0.1
  moment 0.1
  collision_type :projectile
  friction 0.0001
  velocity 1
  # plays 'missile/sound.mp3', :volume => 0.3
  layer Layer::Players
  
  # Generates a number of explosions when destroyed!
  #
  def destroy!
    explosion = SmallExplosion.new window
    explosion.warp position + random_vector(rand(10))
    window.register explosion
    super
  end
  
  def deviate
    @deviation ||= 0
    @deviation += (rand-0.5)/100
    self.position += (self.rotation_vector.perp * @deviation)
  end
  
  def move
    obey_gravity
    deviate
    accelerate 1.5
    on_hitting_y { destroy!; return }
    bounce_off_border_y # a helper method that makes the player bounce off the walls 100% elastically
    wrap_around_border_x # a helper method that makes the player wrap around the border
    rotate_towards_velocity if self.current_speed > 30
  end
  
end