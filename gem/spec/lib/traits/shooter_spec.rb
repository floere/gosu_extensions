require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Shooter do
  
  before(:each) do
    @shooter = test_class_with(Shooter).new :some_window
  end
  
  describe 'muzzle_rotation' do
    context 'default' do
      it 'should use the default calculation' do
        @shooter.stub! :rotation => :some_rotation
        
        @shooter.muzzle_rotation.should == :some_rotation
      end
    end
    context 'non-default' do
      before(:each) do
        @shooter_class = test_class_with(Shooter) do
          muzzle_rotation { :some_rotation_calculation_result }
        end
      end
      it 'should set the shooting_range' do
        @shooter_class.new(:some_window).muzzle_rotation.should == :some_rotation_calculation_result
      end
    end
  end
  
  describe 'muzzle_velocity' do
    context 'default' do
      it 'should use the default calculation' do
        @shooter.stub! :rotation_vector => :some_velocity
        
        @shooter.muzzle_velocity.should == :some_velocity
      end
    end
    context 'non-default' do
      before(:each) do
        @shooter_class = test_class_with(Shooter) do
          muzzle_velocity { :some_velocity_calculation_result }
        end
      end
      it 'should set the shooting_range' do
        @shooter_class.new(:some_window).muzzle_velocity.should == :some_velocity_calculation_result
      end
    end
  end
  
  describe 'muzzle_position' do
    context 'default' do
      it 'should use the default calculation' do
        @shooter.stub! :position => "position + ", :rotation_vector => "rotation", :radius => 3
        
        @shooter.muzzle_position.should == "position + rotationrotationrotation"
      end
    end
    context 'non-default' do
      before(:each) do
        @shooter_class = test_class_with(Shooter) do
          muzzle_position { :some_position_calculation_result }
        end
      end
      it 'should set the shooting_range' do
        @shooter_class.new(:some_window).muzzle_position.should == :some_position_calculation_result
      end
    end
  end
  
  describe 'shoots' do
    before(:each) do
      @shooter_class = test_class_with(Shooter) do
        shoots :some_type
      end
    end
    it 'should set the shooting_range' do
      @shooter_class.new(:some_window).shot_type.should == :some_type
    end
  end
  
  describe 'frequency' do
    before(:each) do
      @shooter_class = test_class_with(Shooter) do
        frequency 3.14
      end
    end
    it 'should set the shooting_rate' do
      @shooter_class.new(:some_window).shooting_rate.should be_close(16, 0.1)
    end
  end
  
  describe 'range' do
    before(:each) do
      @shooter_class = test_class_with(Shooter) do
        range :some_range
      end
    end
    it 'should set the shooting_range' do
      @shooter_class.new(:some_window).shooting_range.should == :some_range
    end
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