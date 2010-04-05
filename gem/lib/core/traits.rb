module Traits
  
  # A List all Traits.
  #
  def self.list
    ObjectSpace.each_object.select { |object| object.kind_of?(Trait) }.sort!{ |moda, modb| moda.to_s <=> modb.to_s }
  end
  
end