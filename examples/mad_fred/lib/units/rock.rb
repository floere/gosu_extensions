class Rock < Thing
  
  image 'rock.png'
  
  shape :circle
  radius 20.0
  mass 10_000
  moment 0.1
  friction 0.1
  rotation { rand*-Math::PI/2 }
  
  collision_type :hurtful
  
  def move
    self.position.x -= 0.5
  end
  
end