class SmallExplosion < ShortLived
  
  # include Hurting
  
  # rotation rand * 2 * Math::PI
  
  lifetime 20
  sequenced_image 'small_explosion.png', 16, 16, 10
  shape :circle
  radius 2.0
  mass 100
  moment 100
  collision_type :projectile
  friction 0.0001
  layer Layer::Background
  
  # plays 'media/sounds/cannon_shot.mp3',
  #       'media/sounds/bomb-02.wav',
  #       'media/sounds/bomb-03.wav',
  #       'media/sounds/bomb-06.wav',
  #       'media/sounds/explosion-01.wav',
  #       'media/sounds/explosion-02.wav',
  #       'media/sounds/explosion-05.wav'
  
  # def initialize window
  #   self.lifetime = 30
  #   
  #   super window
  #   
  #   @start = Time.now
  #   
  #   @image = Gosu::Image::load_tiles window, "media/small_explosion.png", 16, 16, false
  #   @shape = CP::Shape::Circle.new CP::Body.new(100, 100), 1.0, CP::Vec2.new(0, 0)
  #   @shape.collision_type = :explosion
  #   
  #   self.rotation = rand * 2 * Math::PI
  #   
  #   sound = [
  #     'media/sounds/cannon_shot.mp3',
  #     'media/sounds/bomb-02.wav',
  #     'media/sounds/bomb-03.wav',
  #     'media/sounds/bomb-06.wav',
  #     'media/sounds/explosion-01.wav',
  #     'media/sounds/explosion-02.wav',
  #     'media/sounds/explosion-05.wav'
  #   ][rand(7)]
  #   @sound = Gosu::Sample.new window, sound
  #   @sound.play
  # end
  
  # def draw
  #   image = @image[(Time.now - @start)*10 % @image.size];
  #   image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation, 0.4, 0.4, 0.4, 0.4
  # end
  
end