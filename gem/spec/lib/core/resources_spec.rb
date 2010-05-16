require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Resources do
  
  it "should have an writer root" do
    lambda { Resources.root = :some_root }.should_not raise_error
  end
  it "should have an reader root" do
    lambda { Resources.root }.should_not raise_error
  end
  
end