class Environment < CP::Space
  
  # Remove body and shape from self.
  #
  def remove shape
    self.remove_body shape.body
    self.remove_shape shape
  end
  
end