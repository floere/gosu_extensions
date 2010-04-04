require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Numeric do
  
  describe "radians_to_vec2" do
    it "should convert radians into a vector" do
      10.0.radians_to_vec2.should be_kind_of(CP::Vec2)
    end
    it "should convert correctly" do
      Math::PI.radians_to_vec2.x.should == -1.0
      Math::PI.radians_to_vec2.y.should be_close 0.0, 0.000001
    end
  end
  
end