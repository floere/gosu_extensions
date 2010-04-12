require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe UserInterface do
  
  before(:each) do
    @window = stub :window
    @user_interface = test_class_with(UserInterface).new @window
  end
  
  describe "ui" do
    before(:each) do
      @font = stub :font, :null_object => true
      @window.stub! :font => @font
      @window.stub! :register_ui
    end
    it "should register itself with window" do
      @window.should_receive(:register_ui).once.with @user_interface
      
      @user_interface.ui
    end
    it "should install a method draw_ui" do
      @user_interface.ui do end
      
      lambda { @user_interface.draw_ui }.should_not raise_error
    end
    it "should do the right thing on calling draw_ui (defaults)" do
      some_block = lambda { :some_result }
      @user_interface.ui &some_block
      
      @font.should_receive(:draw).once.with :some_result, 20, 10, Layer::UI, 1.0, 1.0, Gosu::Color::BLACK
      
      @user_interface.draw_ui 
    end
    it "should do the right thing on calling draw_ui" do
      some_block = lambda { :some_result }
      @user_interface.ui :some_x, :some_y, :some_color, &some_block
      
      @font.should_receive(:draw).once.with :some_result, :some_x, :some_y, Layer::UI, 1.0, 1.0, :some_color
      
      @user_interface.draw_ui 
    end
  end
  
end