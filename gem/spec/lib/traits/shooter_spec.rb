require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Shooter do
  
  before(:each) do
    @shooter = Class.new do
      it_is_a Shooter
    end
  end
  it "should define a constant Shoot" do
    Shooter::Shoot.should == :shoot
  end
  
end