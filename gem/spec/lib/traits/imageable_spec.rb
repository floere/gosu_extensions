require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Imageable do
  
  before(:each) do
    @window = stub :window, :things => []
    Resources.stub! :root => 'some/root'
  end
  
  describe 'image=' do
    before(:each) do
      @imageable = test_class_with(Imageable).new @window
    end
    it 'should set the image' do
      lambda { @imageable.image = :some_image }.should_not raise_error
    end
    it 'should return that image' do
      @imageable.image = :some_image
      
      @imageable.image.should == :some_image
    end
  end

  context 'image defined on class' do
    before(:each) do
      @imageable_class = test_class_with(Imageable) do
        image 'some/path.png'
      end
    end
    it "should define a method lifetime which returns the result of the block" do
      Gosu::Image.stub! :new => :some_image
      
      @imageable_class.new(@window).image.should == :some_image
    end
  end
  context 'sequenced image defined on class' do
    before(:each) do
      @imageable_class = test_class_with(Imageable) do
        sequenced_image 'some/path', :some_width, :some_height, 10.0
      end
    end
    it "should define a method image" do
      image = stub :image
      sequenced_image = stub :image, :size => 10, :[] => image
      
      Gosu::Image.stub! :load_tiles => sequenced_image
      
      @imageable_class.new(@window).image.should == image
    end
  end
  context 'no image given – what now?' do
    before(:each) do
      @imageable_class = test_class_with Imageable
    end
    it "should raise a ImageMissingError" do
      lambda { @imageable_class.new(@window).image }.should raise_error(Imageable::ImageMissingError)
    end
    it "should raise with the right message" do
      lambda { @imageable_class.new(@window).image }.should raise_error(Imageable::ImageMissingError, <<-MESSAGE
        
        In an Imageable, you either need to define method
          image path, *args
        for an unchanging image
        or
          sequenced_image path, width, height, frequency = 10, &block
        for a sprite sequence.
        Or override
          method image
        or set an image dynamically.
        
      MESSAGE
      )
    end
  end
  
end