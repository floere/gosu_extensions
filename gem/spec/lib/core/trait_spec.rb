require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe "Trait" do
  
  it "should define a constant" do
    lambda { Trait }.should_not raise_error
  end
  
end