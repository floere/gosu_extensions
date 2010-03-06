#
class Smoke < ShortLived
  
  lifetime { 50 + rand(10) }
  sequenced_image 'smoke.png', 10, 10, 1
  shape :circle
  radius 1.0
  mass 0.1
  moment 0.1
  collision_type :projectile
  friction 0.0001
  layer Layer::Background
  
end