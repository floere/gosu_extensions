class Module
  
  def manual text
    metaclass.send :define_method, :manual! do
      puts <<-MANUAL
    MANUAL FOR #{self}
#{text}
    Change #{self}.manual! -> #{self}, to not show the manual anymore.
    
      MANUAL
      self
    end
  end
  
end