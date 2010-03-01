# This game will have multiple Players in the form of a ship.
#
class MissileLauncher < Moveable
  
  it_is Targeting::Closest
  it_is_a Shooter
  
  image 'media/gun.png'
  shape :circle
  radius 3.0
  mass 1000.0
  moment 75.0
  layer Layer::Players
  collision_type :gun
  
  range 600
  frequency 120
  shoots Missile
  
  muzzle_position { self.position }
  muzzle_velocity { |target| (target.position - self.muzzle_position[] + self.random_vector(1 + rand(20))).normalize }
  muzzle_rotation { |target| (target.position - self.muzzle_position[]).to_angle }
  
  # def initialize window
  #   super window
  #   
  #   # @image = Gosu::Image.new window, "media/gun.png", false
  #   # 
  #   # @shape = CP::Shape::Circle.new CP::Body.new(1000.0, 75.0), 3.0, CP::Vec2.new(0, 0)
  #   # @shape.collision_type = :gun
  #   
  #   # accuracy = 1 + rand(20)
  #   # 
  #   # # self.shoots Projectile
  #   # self.muzzle_position_func { self.position }
  #   # self.muzzle_velocity_func { |target| (target.position - self.muzzle_position[] + self.random_vector(accuracy)).normalize }
  #   # self.muzzle_rotation_func { |target| (target.position - self.muzzle_position[]).to_angle }
  #   # self.range = 600
  #   # self.frequency = 120
  #   
  #   # Metaprog this
  #   # @sound = Gosu::Sample.new window, 'media/sounds/cannon_shot.mp3'
  # end
  
  # def target *targets
  #   return if targets.empty?
  #   target = acquire *targets
  #   shoot target
  # end
  
  # def draw
  #   @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  # end
end