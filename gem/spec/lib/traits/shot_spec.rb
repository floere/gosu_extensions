require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Shot do
  
  before(:each) do
    @shot = Class.new do
      include Shot
    end.new 
  end
  it "should define an attr_reader :velocity" do
    lambda { @shot.velocity }.should_not raise_error
  end
  it "should define an attr_writer :velocity" do
    lambda { @shot.velocity = :some_value }.should_not raise_error
  end
  it "should define an attr_reader :originator" do
    lambda { @shot.originator }.should_not raise_error
  end
  it "should define an attr_writer :originator" do
    lambda { @shot.originator = :some_value }.should_not raise_error
  end
  
  describe "shoot_from" do
    before(:each) do
      @shot.stub :position= => nil, :show => nil
      @shot.stub :window => stub(:window)
      @shooter = stub :shooter, :muzzle_position => :some_muzzle_position
    end
    it "should return itself" do
      @shot.shoot_from(@shooter).should == @shot
    end
    it "should set its position to the muzzle position of the shooter" do
      @shot.should_receive(:position=).once.with :some_muzzle_position
      
      @shot.shoot_from @shooter
    end
    it "should set its originator to the shooter" do
      @shot.should_receive(:originator=).once.with @shooter
      
      @shot.shoot_from @shooter
    end
    it "should show itself" do
      @shot.should_receive(:show).once
      
      @shot.shoot_from @shooter
    end
  end
  
end