class Numeric
  
  # Convenience method for converting from radians to a Vec2 vector.
  #
  def radians_to_vec2
    CP::Vec2.new Math::cos(self), Math::sin(self)
  end
  
  # Returns whether the number is close to the given one.
  #
  def close_to? number, e
    self < (number+e) && self > (number-e)
  end
  
end