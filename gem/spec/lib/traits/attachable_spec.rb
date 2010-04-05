require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Attachable do
  
  before(:each) do
    @attachable = test_class_with(Attachable).new stub(:window)
  end
  
  describe "move_relative" do
    before(:each) do
      @attachable.stub! :relative_position => "+ attachable position", :position= => nil, :rotation= => nil
      @pod = stub :pod, :position => "pod position ", :rotation => :some_rotation
    end
    it "should set the position to the pod's position plus the relative position" do
      @attachable.should_receive(:position=).once.with "pod position + attachable position"
      
      @attachable.move_relative @pod
    end
    it "should set the rotation to the pod's rotation" do
      @attachable.should_receive(:rotation=).once.with :some_rotation
      
      @attachable.move_relative @pod
    end
  end
  
  describe "relative_position" do
    it "should be a writer" do
      lambda { @attachable.relative_position = :some_position }.should_not raise_error
    end
    it "should have a reader" do
      lambda { @attachable.relative_position }.should_not raise_error
    end
    it "should read what is written" do
      @attachable.relative_position = :some_position
      @attachable.relative_position.should == :some_position
    end
  end
  
end