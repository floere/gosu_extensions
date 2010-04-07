require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Control do
  
  before(:each) do
    @window       = stub :window
    @controllable = stub :controllable
  end
  
  describe 'handle' do
    before(:each) do
      @window.should_receive(:button_down?).any_number_of_times.with(:some_key).and_return true
      @control = Control.new @window, @controllable, { :some_key => :some_command }
    end
    context 'controllable not destroyed' do
      before(:each) do
        @controllable.stub! :destroyed? => false
      end
      it 'should just return' do
        @controllable.should_receive(:some_command).once.with
        
        @control.handle
      end
    end
    context 'controllable destroyed' do
      before(:each) do
        @controllable.stub! :destroyed? => true
      end
      it 'should just return' do
        @controllable.should_receive(:some_command).never
        
        @control.handle
      end
    end
  end
  
  describe 'mapping?' do
    context 'no controllable mapping, no direct mapping' do
      before(:each) do
        @control = Control.new @window, @controllable
      end
      it 'should return false' do
        @control.mapping?.should == false
      end
    end
    context 'with controllable mapping, empty' do
      before(:each) do
        @controllable.stub! :controls_mapping => {}
        @control = Control.new @window, @controllable
      end
      it 'should return false' do
        @control.mapping?.should == false
      end
    end
    context 'with controllable mapping, non-empty' do
      before(:each) do
        @controllable.stub! :controls_mapping => { :non_empty => :mapping }
        @control = Control.new @window, @controllable
      end
      it 'should return true' do
        @control.mapping?.should == true
      end
    end
    context 'with direct mapping, empty' do
      before(:each) do
        @control = Control.new @window, @controllable, {}
      end
      it 'should return false' do
        @control.mapping?.should == false
      end
    end
    context 'with direct mapping, non-empty' do
      before(:each) do
        @control = Control.new @window, @controllable, :non_empty => :mapping
      end
      it 'should return true' do
        @control.mapping?.should == true
      end
    end
  end
  
end