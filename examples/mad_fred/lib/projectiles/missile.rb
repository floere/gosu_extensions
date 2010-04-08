#
#
class Missile < Thing
  
  it_is Turnable
  turn_speed 1
  
  layer Layer::Players
  
  sequenced_image 'missile.png', 14, 64
  
  it_is_a Shot
  it_is_a Generator
  generates Smoke, :starting_at => 15, :every => 10
  
  shape :circle
  radius 1.0
  mass 0.1
  moment 0.1
  friction 0.0001
  velocity 1
  
  collision_type :player_projectile
  
  it_is Controllable
  controls Gosu::Button::KbN => Turnable::Left,
           Gosu::Button::KbM => Turnable::Right
  
  def deviate
    @deviation ||= 0
    @deviation += (rand-0.5)/100
    self.position += (self.rotation_vector.perp * @deviation)
  end
  def move
    accelerate 1.3
    self.position.x -= window.current_speed/2
    on_hitting_x { destroy!; return }
    on_hitting_y { destroy!; return }
  end
  
end