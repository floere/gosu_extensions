class Environment < CP::Space
  
  # Remove body and shape from self.
  #
  def remove thing
    shape = thing.shape
    self.remove_body shape.body
    self.remove_shape shape
  end
  
end