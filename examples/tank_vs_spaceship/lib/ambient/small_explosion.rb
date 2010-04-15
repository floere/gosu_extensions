class SmallExplosion < Thing
  
  it_is_a Generator
  generates Smoke, :starting_at => 10, :every => 5, :until => 25
  
  it_is ShortLived
  lifetime { 15 + rand(15) }
  
  sequenced_image 'small_explosion.png', 16, 16, 10
  shape :circle, 3.0
  mass 100
  moment 100
  collision_type :projectile
  
  friction 0.0001
  random_rotation
  
  def current_size
    @size_multiplicator ||= 2.0
    @size_multiplicator *= 0.95
    [@size_multiplicator, @size_multiplicator]
  end
  
  # plays 'media/sounds/cannon_shot.mp3',
  #       'media/sounds/bomb-02.wav',
  #       'media/sounds/bomb-03.wav',
  #       'media/sounds/bomb-06.wav',
  #       'media/sounds/explosion-01.wav',
  #       'media/sounds/explosion-02.wav',
  #       'media/sounds/explosion-05.wav'
  
end