require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Shooter do
  
  before(:each) do
    @shooter = Class.new do
      include Shooter
    end.new
  end
  
  describe 'shooting_rate' do
    context 'default' do
      it 'should return the default' do
        @shooter.shooting_rate.should == 50.0
      end
    end
    context 'non-default' do
      before(:each) do
        @shooter.shooting_rate = :some_rate
      end
      it 'should return the set range' do
        @shooter.shooting_rate.should == :some_rate
      end
    end
  end
  
  describe 'shooting_range' do
    context 'default' do
      it 'should return the default' do
        @shooter.shooting_range.should == 300
      end
    end
    context 'non-default' do
      before(:each) do
        @shooter.shooting_range = :some_range
      end
      it 'should return the set range' do
        @shooter.shooting_range.should == :some_range
      end
    end
  end
  
  it "should define a constant Shoot" do
    Shooter::Shoot.should == :shoot
  end
  it 'should have a reader shot_type' do
    lambda { @shooter.shot_type }.should_not raise_error
  end
  it 'should have a writer shot_type' do
    lambda { @shooter.shot_type = :some_shot_type }.should_not raise_error
  end
  it 'should have a writer shooting_range' do
    lambda { @shooter.shooting_range = :some_range }.should_not raise_error
  end
  it 'should have a writer shooting_rate' do
    lambda { @shooter.shooting_rate = :some_rate }.should_not raise_error
  end
  
end