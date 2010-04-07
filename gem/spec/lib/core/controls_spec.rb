require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Controls do
  
  describe 'handle' do
    before(:each) do
      @handler1 = stub :handler1
      @handler2 = stub :handler2
      @handler3 = stub :handler3
      
      @controls = Controls.new @handler2, @handler1, @handler3
    end
    it 'should call each handle method' do
      @handler1.should_receive(:handle).once.with
      @handler2.should_receive(:handle).once.with
      @handler3.should_receive(:handle).once.with
      
      @controls.handle
    end
  end
  
  describe 'remove_all_of' do
    before(:each) do
      @controllable = stub :controllable
      @remove    = stub :remove, :controllable => @controllable
      @nonremove = stub :nonremove, :controllable => :some_other_controllable
      
      @controls = Controls.new @remove, @nonremove, @remove, @nonremove, @nonremove, @nonremove
    end
    it 'should remove the right control' do
      @controls.remove_all_of @controllable
      
      @controls.controls.size.should == 4
    end
  end
  
  describe '<<' do
    before(:each) do
      @controls = Controls.new
      @control = stub :control
    end
    it 'should not add nil' do
      @control = nil
      
      @controls << @control
      
      @controls.controls.empty?.should == true
    end
    it 'should not add mapping? false' do
      @control.stub! :mapping? => false
      
      @controls << @control
      
      @controls.controls.empty?.should == true
    end
    it 'should add non-nil, mapping? true' do
      @control.stub! :mapping? => true
      
      @controls << @control
      
      @controls.controls.size.should == 1
    end
  end
  
end