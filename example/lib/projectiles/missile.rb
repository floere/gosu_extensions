#
class Missile < ShortLived
  
  it_is_a Shot
  it_is_a Generator
  generates Smoke, :every => 10, :until => 50, :starting_at => 5
  
  lifetime { 100 + rand(100) }
  image 'missile.png'
  shape :circle
  radius 1.0
  mass 0.1
  moment 0.1
  collision_type :projectile
  friction 0.0001
  velocity { 4 + rand(1) }
  # plays 'cannon-02.wav'
  layer Layer::Players
  
  # Generates a number of explosions when destroyed!
  #
  def destroy!
    explosion = SmallExplosion.new window
    explosion.warp position + random_vector(rand(10))
    window.register explosion
    super
  end
  
  def move
    destroy_on_hitting_y and return
    bounce_off_border_y # a helper method that makes the player bounce off the walls 100% elastically
    wrap_around_border_x # a helper method that makes the player wrap around the border
  end
  
end