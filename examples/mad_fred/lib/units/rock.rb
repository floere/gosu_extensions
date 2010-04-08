class Rock < Thing
  
  layer Layer::Players
  
  image 'rock.png'
  
  shape :circle
  radius 20.0
  mass 10_000
  moment 0.1
  friction 0.1
  rotation { rand*-Math::PI/2 }
  
  collision_type :hurtful
  
  def move
    self.position.x -= window.current_speed
    on_hitting_x { destroy!; return }
  end
  
end