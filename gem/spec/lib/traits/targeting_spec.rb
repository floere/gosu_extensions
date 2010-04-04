require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Targeting do
  
  it "should define a module" do
    Targeting.class.should == Module
  end
  
end