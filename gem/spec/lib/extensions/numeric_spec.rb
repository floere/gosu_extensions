require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Numeric do
  
  describe "radians_to_vec2" do
    it "should convert radians into a vector" do
      10.0.radians_to_vec2.should == nil
    end
  end
  
end