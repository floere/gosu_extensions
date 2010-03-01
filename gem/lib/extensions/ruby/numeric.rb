class Numeric
  
  # Convenience method for converting from radians to a Vec2 vector.
  #
  def radians_to_vec2
    CP::Vec2.new Math::cos(self), Math::sin(self)
  end
  
end