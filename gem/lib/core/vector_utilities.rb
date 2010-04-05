#
#
module VectorUtilities
  
  # Return a random vector with a given strength.
  #
  def random_vector strength = 1.0
    CP::Vec2.new(rand-0.5, rand-0.5).normalize! * strength
  end
  
end